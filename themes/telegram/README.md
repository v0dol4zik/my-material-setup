# Material 2 Green for Telegram Desktop

A dark theme matching the Niri/Noctalia rice: graphite surfaces, the wallpaper's
`#25e075` green accent, pale text, and dim green outgoing message bubbles.
The chat background uses original low-contrast geometry, not a copy of the
desktop wallpaper. Bright green buttons have dark text for legibility.

## Import

The ready-to-import archive is `Material2-Green.tdesktop-theme`.

In Telegram Desktop, open **Settings → Chat Settings → ⋮ → Choose from file**
(the wording/menu location may vary), select the archive, preview, and apply it.
No account files, messages, or Telegram settings are edited by this repository's
installer. Choose your previous theme in Chat Settings to revert.

Русский: **Настройки → Настройки чатов → ⋮ → Выбрать из файла**. Выберите
`Material2-Green.tdesktop-theme`, посмотрите предпросмотр и примените тему.

A color theme does not change Telegram's widget geometry or fonts; those remain
controlled by the application. The palette was checked against the embedded
theme roles in Telegram Desktop **7.2.8**. Actual rendering should be checked in
Telegram's preview before applying.

## Contents and rebuild

- `material2-green/colors.tdesktop-theme`: 556 explicit color-role definitions.
- `material2-green/background.svg`: editable original background.
- `material2-green/background.png`: raster background included in the archive.
- `validate.mjs`: syntax, archive, color-role, and contrast checks.

From this directory, with ImageMagick, libarchive and Node.js installed:

```bash
magick -background none material2-green/background.svg material2-green/background.png
bsdtar --format zip -cf Material2-Green.tdesktop-theme -C material2-green colors.tdesktop-theme background.png
node validate.mjs
```

## Attribution

Color-role names and fallback values were adapted from the embedded dark and
default palettes of [Telegram Desktop](https://github.com/telegramdesktop/tdesktop)
7.2.8; no private Telegram data was read. Refer to the
[upstream license](https://github.com/telegramdesktop/tdesktop/blob/dev/LICENSE)
for the inherited material's terms; the repository-wide MIT declaration does not
override them. The custom background SVG and validation script are original
additions covered by the repository's MIT license.
