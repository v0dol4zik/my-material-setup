# Gruvbox Noctalia Dotfiles

**English** | [Русский](README.ru.md)

A warm, minimalist Gruvbox rice for CachyOS/Arch Linux built around Niri and
Noctalia 5. The configuration is designed to stay compact, translucent, and
practical for everyday use.

## What's included

- Niri: `11` px window rounding, blur, disabled top-left hot corner, and
  ready-to-use Noctalia keybindings.
- Noctalia: floating panel, Gruvbox colors, `0.75` opacity, compact
  notifications and OSDs, a glass-style Control Center, and idle lock.
- Kitty: Gruvbox colors, `0.75` opacity, `12` px padding, and practical
  scrollback and clipboard settings.
- Fish with Pure, Fastfetch, Btop, Vim, and GTK using a shared palette.
- Bibata Modern Classic cursor at size `20`.
- `gruvbox-boxes.png` wallpaper.

## Requirements

The primary package set is:

```text
niri noctalia kitty fish fish-pure-prompt fish-autopair
fastfetch btop vim papirus-icon-theme adw-gtk-theme
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
~/.local/state/gruvbox-noctalia-dotfiles/backups/<date-time>/
```

After installation, log out of the current graphical session and log back
into Niri.

## Main Niri keybindings

| Shortcut | Action |
|---|---|
| `Mod+Return` | Kitty |
| `Mod+B` | Firefox |
| `Mod+E` | Nautilus |
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
├── assets/                 # wallpaper
├── config/                 # contents of ~/.config
├── home/vimrc              # installed as ~/.vimrc
├── state/noctalia/         # portable theme and wallpaper template
├── install.sh
├── README.md
└── README.ru.md
```

## Customization

- Panel: `config/noctalia/config.toml`, section `[bar.main]`.
- Kitty opacity: `config/kitty/kitty.conf`.
- Fish/Pure colors: `config/fish/config.fish`.
- Niri keybindings: `config/niri/cfg/keybinds.kdl`.
- Displays: `config/niri/cfg/display.kdl`.

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

The `gruvbox-boxes.png` wallpaper was provided by the user. Before publishing
or redistributing this repository, make sure the original image license permits
redistribution, or replace it with your own wallpaper.
