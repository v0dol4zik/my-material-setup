# Material 2 Green · Niri + Noctalia

**English** | [Русский](README.ru.md)

[![CachyOS / Arch](https://img.shields.io/badge/CachyOS%20%2F%20Arch-1793D1?style=flat-square&logo=archlinux&logoColor=white)](https://cachyos.org)
[![Niri](https://img.shields.io/badge/WM-Niri-6237D5?style=flat-square&logo=wayland&logoColor=white)](https://github.com/YaLTeR/niri)
[![Noctalia](https://img.shields.io/badge/Shell-Noctalia%205.1-25E075?style=flat-square)](https://noctalia.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-1E1E1E?style=flat-square)](LICENSE)

My dark **Material Design 2** rice for CachyOS and Arch Linux, inspired by ChromeOS: graphite surfaces, a green accent, Roboto typography, small corner radii, and soft shadows. Built around Niri's scrolling tiling layout and the Noctalia shell.

The `#25E075` accent is sampled from the green geometric wallpaper. It ties together the panel, text selection, active window border, terminal, and Telegram theme.

## What's included

| Component | Configuration |
|---|---|
| Windows | Niri: 4 px corner radius, 12 px gaps, 2 px focus ring |
| Desktop shell | Noctalia 5.1 with TOML configuration |
| Panel | At the top, flush with the screen edges, 40 px tall, 78% opacity |
| Workspaces | Minimal text labels without the active application's icon |
| Menus | Application grid, translucent control center, and background blur |
| Terminal | Kitty: Roboto Mono Nerd Font, 14 px padding, 82% opacity |
| Command shell | Fish + Pure: a single-line prompt with the current directory, Git status, and a red error indicator |
| GTK 3/4 | `adw-gtk3-dark`, Material 2 CSS, Roboto 11, and Papirus Dark |
| Cursor | Bibata Modern Classic, size 20 |
| Utilities | Configurations for Fastfetch, Btop, and Vim |
| Telegram Desktop | A separate Material 2 Green theme for manual import |

Notifications are compact, with at most two visible at once. The lock screen uses a dimmed wallpaper and a small login box with keyboard layout and Caps Lock indicators. The session locks after 10 minutes of inactivity, and the screen turns off after 20 minutes.

Keyboard shortcuts launch **Helium Browser** and **Thunar**. Helium keeps its default appearance. The control center is configured to open near the point you click on the panel.

### Palette

| Role | Color |
|---|---|
| Main background | `#121212` |
| Surfaces | `#1E1E1E` — `#2C2C2C` |
| Accent | `#25E075` |
| Text | `#E8EAED` |

The **Material2-Blue** palette and Blue Paper wallpaper are also kept in the repository.

## Requirements

This setup primarily targets CachyOS. On Arch Linux, you need compatible versions of Niri and Noctalia; you may need to install the `noctalia` package separately. The configuration uses Noctalia 5.1 with the `noctalia` command and a Niri build that supports `blur` and `background-effect`.

The `--install-packages` flag installs the following packages through `pacman`:

```text
niri noctalia kitty fish fish-pure-prompt fish-autopair
fastfetch btop vim papirus-icon-theme adw-gtk-theme
ttf-roboto ttf-roboto-mono-nerd
```

Cloning requires `git`; the installer requires Bash, `curl`, and `tar` with `.xz` support. The cursor is downloaded from GitHub, so an internet connection is required even when installing without packages.

Install Helium, Thunar, and Telegram separately. For X11 applications, `xwayland-satellite` is useful; desktop integration and screen sharing require properly configured `xdg-desktop-portal`, `xdg-desktop-portal-gnome`, and `xdg-desktop-portal-gtk`.

## Installation

Clone the repository and preview the installation plan:

```bash
git clone https://github.com/v0dol4zik/my-material-setup.git
cd my-material-setup
bash ./install.sh --dry-run --install-packages
```

To install packages and configuration files:

```bash
bash ./install.sh --install-packages
```

If the dependencies are already installed, run:

```bash
bash ./install.sh
```

Run the script as your regular user. It invokes `sudo pacman` when installing packages; configuration files are written to your home directory.

### What the installer changes

- Copies the Niri, Noctalia, Kitty, Fish, Fastfetch, Btop, and GTK 3/4 configurations to `~/.config`.
- Installs `home/vimrc` as `~/.vimrc`.
- Downloads Bibata Modern Classic `v2.0.7` to `~/.icons`.
- Writes `~/.local/state/noctalia/settings.toml` with the green palette, wallpaper, and color templates.
- Backs up existing configuration files, Noctalia settings, and the cursor before overwriting them.

Configuration and state locations respect `XDG_CONFIG_HOME` and `XDG_STATE_HOME`. The paths shown here use the defaults.

The installer does not configure SDDM or another display manager, or change your login shell to Fish. To try Fish, run `fish` in a terminal. Your Helium profile and Telegram theme are not changed automatically.

After installation, validate the configuration:

```bash
niri validate
noctalia config validate
```

Then log out and log into Niri. Noctalia is launched by Niri's startup configuration. Restart any open GTK applications and terminals to apply the new appearance.

## Keyboard shortcuts

`Mod` is the **Super / Win** key.

| Shortcut | Action |
|---|---|
| `Mod+Return` | Kitty |
| `Mod+B` | Helium Browser |
| `Mod+E` | Thunar |
| `Mod+Ctrl+Return` | Application launcher |
| `Mod+S` | Control center |
| `Mod+Shift+S` | Noctalia settings |
| `Mod+Shift+Return` | Wallpaper picker |
| `Mod+Alt+L` | Lock the screen |
| `Mod+Shift+Q` | Session menu |
| `Mod+O` | Window and workspace overview |
| `Mod+H/J/K/L` or `Mod+arrow keys` | Move focus |
| `Mod+Ctrl+H/L` | Move the column left / right |
| `Mod+Ctrl+J/K` | Move the window down / up |
| `Mod+Q` | Close the window |
| `Mod+F` | Expand the column to full width |
| `Mod+Shift+F` | Toggle fullscreen for the window |
| `Mod+T` | Toggle floating mode for the window |
| `Mod+W` | Toggle column tabs |
| `Mod+C` | Center the column |
| `Mod+Minus` / `Mod+Equal` | Decrease / increase column width by 10% |
| `Mod+1…9` | Switch to a workspace |
| `Mod+Ctrl+1…9` | Move the column to a workspace |
| `Mod+Tab` | Previous workspace |
| `Mod+Shift+arrow keys` | Move focus between monitors |
| `Mod+Ctrl+Shift+arrow keys` | Move the column to another monitor |
| `Ctrl+Shift+1` / `2` / `3` | Screenshot of an area / screen / window |
| `Alt+Shift` | Switch between US / RU keyboard layouts |
| `Mod+Shift+Esc` | Show the keyboard shortcut help |

Automatic screenshot saving to files is disabled in the configuration: screenshots go to the clipboard. The full list of shortcuts is in [keybinds.kdl](config/niri/cfg/keybinds.kdl).

## Customization

Paths in the table are relative to the repository. For an installed setup, edit the corresponding files in `~/.config`.

| What to change | Where |
|---|---|
| Panel and workspaces | `config/noctalia/config.toml`: `[bar.main]`, `[widget.workspaces]` |
| Control center, transparency, and shadows | `config/noctalia/config.toml`: `[shell.panel]`, `[shell.shadow]`, `[control_center]` |
| Notifications, lock screen, and idle timers | `config/noctalia/config.toml`: `[notification]`, `[lockscreen_widgets]`, `[idle]` |
| Accent and other colors | `config/noctalia/palettes/Material2-Green.json` |
| Default wallpaper | `config/noctalia/wallpapers/material2-green.jpg` |
| GTK control shapes | `config/gtk-3.0/material2.css`, `config/gtk-4.0/material2.css` |
| Terminal transparency and font | `config/kitty/kitty.conf` |
| Fish and Pure colors | `config/fish/config.fish` |
| Keyboard shortcuts and layouts | `config/niri/cfg/keybinds.kdl`, `config/niri/cfg/input.kdl` |
| Monitors and scaling | `config/niri/cfg/display.kdl` |

To list monitor names and available modes, run:

```bash
niri msg outputs
```

The example monitor configuration in `display.kdl` is disabled with `/-`. The lock screen login box is tied to `eDP-1`: for another display, change `output`, the `lockscreen-login-box@eDP-1` identifier, and its entry in `widget_order`. You can adjust its position and size through the Noctalia interface.

The palette is fixed: changing the wallpaper does not replace the green accent. Noctalia applies colors to GTK, Kitty, Btop, Niri, and Qt through its built-in templates. The additional `material2.css` files define GTK control shapes separately from the generated colors; the final appearance depends on each application's theme support.

Running the installer again reapplies the palette, wallpaper, and settings from the repository. To keep your changes, copy them into the configuration files and [state template](state/noctalia/settings.toml.in) before running the installer.

## Telegram Desktop theme

Ready to import: [Material2-Green.tdesktop-theme](themes/telegram/Material2-Green.tdesktop-theme).

In Telegram, open **Settings → Chat Settings → theme menu → Choose from file**, select the archive, and apply it after previewing it. Menu labels may vary between client versions.

The theme includes dark message bubbles, green accents, and a subtle geometric chat background. Details and source files are in [themes/telegram](themes/telegram/README.md).

## Repository structure

```text
.
├── assets/                    # Additional wallpapers from the previous setup
├── config/
│   ├── niri/                  # Compositor configuration, keybindings, and scripts
│   ├── noctalia/              # Panel, menus, palettes, and wallpapers
│   ├── kitty/                 # Terminal
│   ├── fish/                  # Shell colors and Pure settings
│   ├── gtk-3.0/               # GTK 3 styling
│   ├── gtk-4.0/               # GTK 4 styling
│   ├── btop/                  # System monitor
│   └── fastfetch/             # System information
├── home/vimrc                 # Installed as ~/.vimrc
├── state/noctalia/            # Theme and wallpaper settings template
├── themes/telegram/           # Telegram theme and its source files
├── install.sh
├── LICENSE
├── README.md
└── README.ru.md
```

## Backups and rollback

By default, the installer saves backups to:

```text
~/.local/state/material2-noctalia-dotfiles/backups/<date-time>/
```

Backups preserve the home directory structure: for example, the old Niri configuration is stored in `.config/niri/`, and Noctalia theme settings are in `.local/state/noctalia/settings.toml`.

To roll back, end your Niri session, choose a backup, and restore the saved files to their original locations. Files newly added by this setup are absent from the old backup; remove them separately for a full rollback. Uninstall packages separately through your package manager.

## Credits and licenses

The configuration files and installer are distributed under the [MIT License](LICENSE).

- [Niri](https://github.com/YaLTeR/niri) — Wayland compositor.
- [Noctalia](https://noctalia.dev) — panel, menus, notifications, and lock screen.
- [Bibata Cursor](https://github.com/ful1e5/Bibata_Cursor) — cursor theme by ful1e5; the installer downloads the official release archive.
- [tgs266](https://www.deviantart.com/tgs266) — author of **Dark Material Design Wallpaper 3 in 4K** (`dark_material_design_wallpaper_3_in_4k_by_tgs266_d9j9h5i.jpg`). The image belongs to its author and is not covered by the repository's MIT license.
- Borrowed parts of the Telegram palette are subject to the upstream terms described in the [theme README](themes/telegram/README.md#attribution).
