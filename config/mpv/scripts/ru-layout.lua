-- Горячие клавиши на русской раскладке.
--
-- mpv получает символ текущей раскладки, а не физическую клавишу, поэтому на
-- ru клавиша f приходит как «а» и полноэкранный режим не включается. Скрипт при
-- старте копирует каждую привязку из input.conf и встроенных в соседнюю клавишу
-- ЙЦУКЕН: f → а, Shift+q → Й, Ctrl+s → Ctrl+ы, g-p → п-з. Привязки, которые
-- уже явно назначены на кириллицу в input.conf, не трогаются.

local latin    = "`qwertyuiop[]asdfghjkl;'zxcvbnm,.~QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>"
local cyrillic = "ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ"

local map = { SHARP = "№" }  -- # в input.conf пишется как SHARP, на ru это Shift+3
do
    local i = 1
    for ch in cyrillic:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        map[latin:sub(i, i)] = ch
        i = i + 1
    end
end

-- Одна клавиша с модификаторами: "Ctrl+s" → "Ctrl+ы", "Q" → "Й".
local function convert_key(key)
    local mods, base = key:match("^(.*%+)(.+)$")
    if not mods then mods, base = "", key end
    local ru = map[base]
    return ru and mods .. ru
end

-- Последовательность вида "g-p" конвертируется по частям. Сам "-" и
-- "Alt+-" — обычные клавиши, их не режем.
local function convert(key)
    if key:find(".%-.") and not key:find("%+%-$") then
        local parts, changed = {}, false
        for part in key:gmatch("[^-]+") do
            local ru = convert_key(part)
            parts[#parts + 1] = ru or part
            changed = changed or ru ~= nil
        end
        return changed and table.concat(parts, "-")
    end
    return convert_key(key)
end

-- Для каждой клавиши берём действующую привязку (с наибольшим приоритетом).
local effective = {}
for _, b in ipairs(mp.get_property_native("input-bindings", {})) do
    if b.section == "default" then
        local cur = effective[b.key]
        if not cur or b.priority > cur.priority then effective[b.key] = b end
    end
end

for key, b in pairs(effective) do
    local ru = convert(key)
    if ru and not effective[ru] then
        mp.command_native({ "keybind", ru, b.cmd, b.comment })
    end
end
