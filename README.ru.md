# Material 2 Green · Noctalia Dotfiles

[English](README.md) | **Русский**

Тёмный райс Material Design 2 для CachyOS/Arch Linux на базе Niri и
Noctalia 5.1. Графитовые поверхности, зелёный акцент, Roboto, небольшие
скругления и мягкие тени создают вид в духе классического ChromeOS.

## Что внутри

- Niri: скругление окон `4`, отступы `12`, рамка фокуса `2`, мягкие тени и
  готовые бинды для Noctalia.
- Noctalia: панель `40` px у краёв экрана с непрозрачностью `0.78`, Material 2 Green,
  сетка приложений, стеклянные меню с размытием, компактные полупрозрачные уведомления, OSD и idle-lock.
- Блокировка: затемнённые обои и небольшое поле входа со скруглением `4` px,
  индикаторами раскладки и Caps Lock; без погоды, плеера и кнопок завершения сеанса.
- Kitty: Material 2, непрозрачность фона `0.82` с размытием, Roboto Mono Nerd Font, padding `14` и настройки
  scrollback/clipboard.
- Fish + Pure: без приветственного баннера, однострочный промпт с каталогом/Git,
  зелёный акцент и красный статус ошибки. Fastfetch, Btop, Vim и GTK в общей палитре.
- Helium остаётся со стандартной темой; установщик не меняет его оформление.
- Telegram Desktop: отдельная [тема Material 2 Green](themes/telegram/README.md)
  с тёмными сообщениями и спокойным геометрическим фоном чатов; импорт вручную.
- GTK 3/4: Roboto 11, скругления `4` px, заполненные поля и зелёное выделение.
- Курсор Bibata Modern Classic размером `20`.
- Выбранные пользователем тёмные Material-обои в 4K от tgs266 с зелёным акцентом.

Фон — `#121212`, поверхности — `#1e1e1e–#2c2c2c`, акцент —
`#25e075`, взятый прямо с обоев; основной текст — `#e8eaed`.
Прежняя синяя палитра и обои Blue Paper сохранены как альтернативы.

## Требования

Основной целевой набор пакетов:

```text
niri noctalia kitty fish fish-pure-prompt fish-autopair
fastfetch btop vim papirus-icon-theme adw-gtk-theme
ttf-roboto ttf-roboto-mono-nerd
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
~/.local/state/material2-noctalia-dotfiles/backups/<дата-время>/
```

Noctalia и Niri подхватывают конфиги автоматически. GTK-приложения и терминалы
нужно открыть заново для загрузки новых стилей. Перезаход в Niri применит всё сразу.

Установщик не меняет профиль, оформление, расширения и параметры запуска Helium.
Прежняя экспериментальная тема `config/helium-material2/` больше не
устанавливается и не включается.

## Основные бинды Niri

| Сочетание | Действие |
|---|---|
| `Mod+Return` | Kitty |
| `Mod+B` | Helium Browser |
| `Mod+E` | Thunar |
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
├── assets/                 # прежние дополнительные изображения (не устанавливаются)
├── config/                 # содержимое ~/.config
├── home/vimrc              # устанавливается как ~/.vimrc
├── state/noctalia/         # переносимый шаблон темы и обоев
├── themes/telegram/        # тема Telegram для ручного импорта
├── install.sh
├── README.md
└── README.ru.md
```

## Настройка под себя

- Панель: `config/noctalia/config.toml`, секция `[bar.main]`.
- Палитра: `config/noctalia/palettes/Material2-Green.json`.
- Обои: `config/noctalia/wallpapers/material2-green.jpg`.
- Формы GTK: `config/gtk-{3,4}.0/material2.css`.
- Прозрачность Kitty: `config/kitty/kitty.conf`.
- Цвета Fish/Pure: `config/fish/config.fish`.
- Уведомления и блокировка: `config/noctalia/config.toml`. Поле входа настроено
  для `eDP-1`; для другого дисплея измените ID виджета и `output`.
- Бинды Niri: `config/niri/cfg/keybinds.kdl`.
- Мониторы: `config/niri/cfg/display.kdl`.

Пользовательская палитра Noctalia использует ключи camelCase и вложенную секцию
`terminal`. Встроенные шаблоны обновляют цвета GTK, Kitty, Btop и Niri;
отдельный импорт `material2.css` сохраняет формы элементов при обновлении цветов.
После правки установленной палитры в `~/.config/noctalia/palettes/` выполните
`noctalia msg config-reload` и `noctalia msg templates-apply`.

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

Установщик выбирает зелёные Material-обои и предварительно сохраняет старые настройки
Noctalia. Обои можно сменить через Noctalia; палитра Material 2 останется фиксированной.

`material2-green.jpg` — предоставленные пользователем обои **Dark Material Design
Wallpaper 3 in 4K** от [tgs266](https://www.deviantart.com/tgs266), исходный файл
`dark_material_design_wallpaper_3_in_4k_by_tgs266_d9j9h5i.jpg`.
На это стороннее изображение не распространяется MIT-лицензия репозитория;
действуют условия автора.
