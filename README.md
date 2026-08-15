# Gruvbox Noctalia Dotfiles

Тёплый минималистичный Gruvbox rice для CachyOS/Arch Linux на базе Niri и
Noctalia 5. Конфиги собраны так, чтобы интерфейс оставался компактным,
полупрозрачным и пригодным для ежедневной работы.

## Что внутри

- Niri: скругление окон `11`, blur, отключённый верхний левый hot corner и
  готовые бинды для Noctalia.
- Noctalia: плавающая панель, Gruvbox, прозрачность `0.75`, компактные
  уведомления и OSD, glass Control Center и idle-lock.
- Kitty: Gruvbox, прозрачность `0.75`, padding `12` и практичные настройки
  scrollback/clipboard.
- Fish + Pure, Fastfetch, Btop, Vim и GTK в общей палитре.
- Курсор Bibata Modern Classic размером `20`.
- Обои `gruvbox-boxes.png`.

## Требования

Основной целевой набор пакетов:

```text
niri noctalia kitty fish fish-pure-prompt fish-autopair
fastfetch btop vim papirus-icon-theme adw-gtk-theme
```

Для загрузки и распаковки курсора также нужны `curl` и `tar` (`tar` входит в
базовую систему Arch).

`noctalia` доступна в репозиториях CachyOS. На чистом Arch её может
потребоваться установить отдельно до запуска скрипта.

## Установка

Сначала посмотрите план установки без изменений:

```bash
./install.sh --dry-run
```

Установить только конфиги:

```bash
./install.sh
```

Установить пакеты через `pacman`, затем конфиги:

```bash
./install.sh --install-packages
```

Установщик не удаляет существующие конфиги безвозвратно. Перед перезаписью он
копирует их в:

```text
~/.local/state/gruvbox-noctalia-dotfiles/backups/<дата-время>/
```

После установки завершите текущую графическую сессию и войдите в Niri снова.

## Основные бинды Niri

| Сочетание | Действие |
|---|---|
| `Mod+Return` | Kitty |
| `Mod+B` | Firefox |
| `Mod+E` | Nautilus |
| `Mod+Ctrl+Return` | Launcher |
| `Mod+S` | Control Center |
| `Mod+Shift+S` | Настройки Noctalia |
| `Mod+Shift+Return` | Выбор обоев |
| `Mod+Alt+L` | Блокировка |
| `Mod+O` | Overview |

Полный список находится в `config/niri/cfg/keybinds.kdl`.

## Структура

```text
.
├── assets/                 # обои
├── config/                 # содержимое ~/.config
├── home/vimrc              # устанавливается как ~/.vimrc
├── state/noctalia/         # переносимый шаблон темы и обоев
├── install.sh
└── README.md
```

## Настройка под себя

- Панель: `config/noctalia/config.toml`, секция `[bar.main]`.
- Прозрачность Kitty: `config/kitty/kitty.conf`.
- Цвета Fish/Pure: `config/fish/config.fish`.
- Бинды Niri: `config/niri/cfg/keybinds.kdl`.
- Мониторы: `config/niri/cfg/display.kdl`.

Конфигурация монитора по умолчанию закомментирована. Получить имена и режимы
подключённых дисплеев можно командой:

```bash
niri msg outputs
```

## Откат

Закройте Niri/Noctalia, затем скопируйте нужные файлы из последнего каталога
резервной копии обратно в домашний каталог. Установщик намеренно не содержит
автоматического удаления или разрушительного `reset`.

## Лицензия

Конфиги и установщик распространяются по лицензии MIT.

[Bibata Cursor](https://github.com/ful1e5/Bibata_Cursor) не хранится в этом
репозитории. Установщик загружает официальный Linux release-архив
`Bibata-Modern-Classic.tar.xz` версии `v2.0.7` напрямую со страницы релизов
проекта и распаковывает его в `~/.icons`.

Обои `gruvbox-boxes.png` добавлены пользователем. Перед публичным
распространением репозитория убедитесь, что лицензия исходного изображения
разрешает публикацию, либо замените файл собственными обоями.
