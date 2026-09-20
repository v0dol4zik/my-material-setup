#!/usr/bin/env node
import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { inflateRawSync } from 'node:zlib';

const directory = dirname(fileURLToPath(import.meta.url));
const source = join(directory, 'material2-green');
const archive = join(directory, 'Material2-Green.tdesktop-theme');
const paletteText = readFileSync(join(source, 'colors.tdesktop-theme'), 'utf8');
const colors = new Map();
for (const [index, line] of paletteText.split(/\r?\n/).entries()) {
  const stripped = line.replace(/\/\/.*$/, '').trim();
  if (!stripped) continue;
  const match = /^([A-Za-z_]\w*):\s*(#[0-9a-f]{6}(?:[0-9a-f]{2})?);$/i.exec(stripped);
  assert(match, `Invalid palette syntax at line ${index + 1}`);
  assert(!colors.has(match[1]), `Duplicate color role ${match[1]}`);
  colors.set(match[1], match[2].toLowerCase());
}
assert.equal(colors.size, 556);
assert.equal(colors.get('activeButtonBg'), '#25e075');
assert.equal(colors.get('windowBg'), '#1e1e1e');

function luminance(hex) {
  const channels = hex.slice(1, 7).match(/../g).map(value => parseInt(value, 16) / 255);
  return channels.map(value => value <= 0.04045 ? value / 12.92 : ((value + 0.055) / 1.055) ** 2.4)
    .reduce((sum, value, index) => sum + value * [0.2126, 0.7152, 0.0722][index], 0);
}
for (const [foreground, background] of [
  ['windowFg', 'windowBg'],
  ['activeButtonFg', 'activeButtonBg'],
  ['historyTextInFg', 'msgInBg'],
  ['historyTextOutFg', 'msgOutBg'],
  ['historyLinkInFg', 'msgInBg'],
  ['historyLinkOutFg', 'msgOutBg'],
  ['msgInDateFg', 'msgInBg'],
  ['msgOutDateFg', 'msgOutBg'],
  ['dialogsTextFgActive', 'dialogsBgActive'],
  ['dialogsUnreadFg', 'dialogsUnreadBg'],
  ['sideBarBadgeFg', 'sideBarBadgeBg'],
]) {
  const values = [luminance(colors.get(foreground)), luminance(colors.get(background))].sort((a, b) => b - a);
  const contrast = (values[0] + 0.05) / (values[1] + 0.05);
  assert(contrast >= 4.5, `${foreground}/${background} contrast is only ${contrast.toFixed(2)}:1`);
  console.log(`${foreground}/${background}: ${contrast.toFixed(2)}:1`);
}

// Read this small ordinary ZIP directly: no subprocess, extraction, or dependencies.
const zip = readFileSync(archive);
let end = -1;
for (let position = zip.length - 22; position >= Math.max(0, zip.length - 65557); position--) {
  if (zip.readUInt32LE(position) === 0x06054b50
      && position + 22 + zip.readUInt16LE(position + 20) === zip.length) {
    end = position;
    break;
  }
}
assert(end >= 0, 'ZIP end-of-directory record is missing');
assert.equal(zip.readUInt16LE(end + 4), 0, 'Multi-disk ZIP is not supported');
assert.equal(zip.readUInt16LE(end + 6), 0);
const count = zip.readUInt16LE(end + 10);
assert.equal(count, 2, 'Theme must have exactly two members');
assert.equal(zip.readUInt16LE(end + 8), count);
let cursor = zip.readUInt32LE(end + 16);
const directoryEnd = cursor + zip.readUInt32LE(end + 12);
assert(directoryEnd <= end, 'Invalid ZIP directory bounds');
const members = new Set();
for (let index = 0; index < count; index++) {
  assert.equal(zip.readUInt32LE(cursor), 0x02014b50);
  const flags = zip.readUInt16LE(cursor + 8);
  const method = zip.readUInt16LE(cursor + 10);
  const expectedCrc = zip.readUInt32LE(cursor + 16);
  const compressedSize = zip.readUInt32LE(cursor + 20);
  const expandedSize = zip.readUInt32LE(cursor + 24);
  const nameSize = zip.readUInt16LE(cursor + 28);
  const extraSize = zip.readUInt16LE(cursor + 30);
  const commentSize = zip.readUInt16LE(cursor + 32);
  const local = zip.readUInt32LE(cursor + 42);
  const member = zip.subarray(cursor + 46, cursor + 46 + nameSize).toString('utf8');
  assert(['background.png', 'colors.tdesktop-theme'].includes(member), `Unexpected archive member: ${member}`);
  assert(!members.has(member), `Duplicate archive member: ${member}`);
  members.add(member);
  assert.equal(flags & 1, 0, 'Encrypted ZIP members are not supported');
  assert.equal(zip.readUInt32LE(local), 0x04034b50);
  const dataStart = local + 30 + zip.readUInt16LE(local + 26) + zip.readUInt16LE(local + 28);
  assert(dataStart + compressedSize <= zip.length);
  const compressed = zip.subarray(dataStart, dataStart + compressedSize);
  assert(method === 0 || method === 8, 'Unsupported ZIP compression');
  const bytes = method === 8 ? inflateRawSync(compressed, { maxOutputLength: 16 * 1024 * 1024 }) : compressed;
  assert.equal(bytes.length, expandedSize);
  let crc = 0xffffffff;
  for (const byte of bytes) {
    crc ^= byte;
    for (let bit = 0; bit < 8; bit++) crc = (crc >>> 1) ^ ((crc & 1) ? 0xedb88320 : 0);
  }
  assert.equal((crc ^ 0xffffffff) >>> 0, expectedCrc, `CRC mismatch: ${member}`);
  assert(bytes.equals(readFileSync(join(source, member))), `Archive member differs: ${member}`);
  cursor += 46 + nameSize + extraSize + commentSize;
}
assert.equal(cursor, directoryEnd);
const background = readFileSync(join(source, 'background.png'));
assert.equal(background.subarray(0, 8).toString('hex'), '89504e470d0a1a0a');
assert.equal(background.readUInt32BE(16), 1920);
assert.equal(background.readUInt32BE(20), 1080);

// Optional compatibility check against installed Telegram's public resources.
// This reads the program binary only, never tdata, chats, or account settings.
const binaryPath = process.argv[2] || '/usr/bin/Telegram';
if (!existsSync(binaryPath)) {
  assert(!process.argv[2], 'The requested Telegram binary does not exist');
  console.log(`OK: ${colors.size} colors; archive, background, and contrast checks passed. Installed Telegram role check skipped.`);
  process.exit(0);
}
const binary = readFileSync(binaryPath);
const signature = Buffer.from([0x50, 0x4b, 0x03, 0x04]);
const known = new Set();
let offset = -1;
while ((offset = binary.indexOf(signature, offset + 1)) !== -1) {
  if (offset + 30 > binary.length || binary.readUInt16LE(offset + 8) !== 8) continue;
  const length = binary.readUInt16LE(offset + 26);
  const extra = binary.readUInt16LE(offset + 28);
  if (length < 1 || length > 128) continue;
  const name = binary.subarray(offset + 30, offset + 30 + length).toString();
  if (!/^colors\.tdesktop-(theme|palette)$/.test(name)) continue;
  const start = offset + 30 + length + extra;
  try {
    const embedded = inflateRawSync(binary.subarray(start, start + 1000000), { maxOutputLength: 1000000 }).toString();
    for (const match of embedded.matchAll(/^([A-Za-z_]\w*)\s*:/gm)) known.add(match[1]);
  } catch { /* A compressed outer resource is not an inline palette. */ }
}
assert(known.size > 400, 'Could not extract installed Telegram color-role definitions');
for (const key of colors.keys()) assert(known.has(key), `Unknown installed Telegram role: ${key}`);
console.log(`OK: ${colors.size} known color roles; archive, background, and contrast checks passed.`);
