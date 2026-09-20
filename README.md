# Material 2 Green · Noctalia Dotfiles

**English** | [Русский](README.ru.md)

A dark Material Design 2 rice for CachyOS/Arch Linux built around Niri and
Noctalia 5.1. Neutral graphite surfaces, green accents, Roboto typography,
small corner radii, and elevation shadows give it a classic ChromeOS feel.

## What's included

- Niri: `4` px window rounding, `12` px gaps, a `2` px focus ring, soft shadows, and
  ready-to-use Noctalia keybindings.
- Noctalia: a flush `40` px top bar at `0.78` opacity, Material 2 Green colors, an app
  grid, glass panels with blur, compact translucent notifications and OSDs, and idle lock.
- Lockscreen: tinted wallpaper and a small `4` px login box with keyboard-layout
  and Caps Lock indicators; weather, media, and session buttons are hidden.
- Kitty: Material 2 colors, `0.82` background opacity with blur, Roboto Mono Nerd Font, `14` px padding, and practical
  scrollback and clipboard settings.
- Fish with Pure: quiet startup, a single-line directory/Git prompt, a green accent,
  and red exit status on errors. Fastfetch, Btop, Vim, and GTK share the palette.
- Helium keeps its standard theme; the installer does not change its appearance.
- Telegram Desktop: an optional [Material 2 Green theme](themes/telegram/README.md)
  with readable dark message bubbles and a quiet geometric chat background.
- GTK 3/4: Roboto 11, `4` px controls, filled fields, and green selection.
- Bibata Modern Classic cursor at size `20`.
- User-selected 4K dark material wallpaper by tgs266, with a matching green accent.

The dark palette uses `#121212` for the background, `#1e1e1e–#2c2c2c`
for surfaces, `#25e075` sampled from the wallpaper for the accent, and `#e8eaed` for text.
The original blue palette and Blue Paper wallpaper remain available as alternatives.

## Requirements

The primary package set is:

```text
niri noctalia kitty fish fish-pure-prompt fish-autopair
fastfetch btop vim papirus-icon-theme adw-gtk-theme
ttf-roboto ttf-roboto-mono-nerd
```

The cursor download and extraction also require `curl` and `tar` (`tar` is
part of the Arch base system).

`noctalia` is available in the CachyOS repositories. On plain Arch Linux, you
may need to install it separately before running the script.

## Installation

Preview the installation plan without changing anything:

```bash
./install.sh --dry-run
```

Install configuration files only:

```bash
./install.sh
```

Install packages with `pacman`, then install the configuration files:

```bash
./install.sh --install-packages
```

The installer never permanently deletes existing configuration files. Before
overwriting them, it copies them to:

```text
~/.local/state/material2-noctalia-dotfiles/backups/<date-time>/
```

Noctalia and Niri reload configuration automatically. Reopen GTK applications
and terminals to load their new styles. Logging out and back into Niri applies
everything at once.

Helium's profile, appearance, extensions, and launch flags are left unchanged.
The earlier experimental `config/helium-material2/` theme is not installed or
enabled by the installer.

## Main Niri keybindings

| Shortcut | Action |
|---|---|
| `Mod+Return` | Kitty |
| `Mod+B` | Helium Browser |
| `Mod+E` | Thunar |
| `Mod+Ctrl+Return` | Launcher |
| `Mod+S` | Control Center |
| `Mod+Shift+S` | Noctalia settings |
| `Mod+Shift+Return` | Wallpaper picker |
| `Mod+Alt+L` | Lock screen |
| `Mod+O` | Overview |

The complete list is available in `config/niri/cfg/keybinds.kdl`.

## Repository structure

```text
.
├── assets/                 # legacy optional artwork (not installed)
├── config/                 # contents of ~/.config
├── home/vimrc              # installed as ~/.vimrc
├── state/noctalia/         # portable theme and wallpaper template
├── themes/telegram/        # manually imported Telegram theme
├── install.sh
├── README.md
└── README.ru.md
```

## Customization

- Panel: `config/noctalia/config.toml`, section `[bar.main]`.
- Palette: `config/noctalia/palettes/Material2-Green.json`.
- Wallpaper: `config/noctalia/wallpapers/material2-green.jpg`.
- GTK shapes: `config/gtk-{3,4}.0/material2.css`.
- Kitty opacity: `config/kitty/kitty.conf`.
- Fish/Pure colors: `config/fish/config.fish`.
- Notifications and lockscreen: `config/noctalia/config.toml`. The login-box layout
  targets `eDP-1`; adapt the widget ID and `output` for another display.
- Niri keybindings: `config/niri/cfg/keybinds.kdl`.
- Displays: `config/niri/cfg/display.kdl`.

Noctalia's custom palette uses camelCase color keys and a nested `terminal`
section. Its built-in templates maintain GTK, Kitty, Btop, and Niri colors;
the separate `material2.css` imports keep control shapes across template updates.
Edit the installed palette in `~/.config/noctalia/palettes/`, then run
`noctalia msg config-reload` and `noctalia msg templates-apply`.

The default display configuration is commented out. List connected displays
and their modes with:

```bash
niri msg outputs
```

## Restoring a backup

Close Niri and Noctalia, then copy the required files from the latest backup
directory back into your home directory. The installer intentionally provides
no automatic removal or destructive `reset` command.

## License

The configuration files and installer are distributed under the MIT License.

[Bibata Cursor](https://github.com/ful1e5/Bibata_Cursor) is not stored in this
repository. The installer downloads the official
`Bibata-Modern-Classic.tar.xz` Linux release archive for version `v2.0.7`
directly from the project's release page and extracts it into `~/.icons`.

The installer selects the green material wallpaper and backs up the old
Noctalia settings first. Choose another wallpaper through Noctalia at any time;
the Material 2 palette stays fixed.

`material2-green.jpg` is the user-provided **Dark Material Design Wallpaper 3 in 4K**
by [tgs266](https://www.deviantart.com/tgs266), original file
`dark_material_design_wallpaper_3_in_4k_by_tgs266_d9j9h5i.jpg`.
This third-party artwork is not covered by the repository's MIT license;
its author's terms apply.
