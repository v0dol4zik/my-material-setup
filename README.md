# Material 2 Green · Niri + Noctalia

**English** | [Русский](README.ru.md)

[![CachyOS / Arch](https://img.shields.io/badge/CachyOS%20%2F%20Arch-1793D1?style=flat-square&logo=archlinux&logoColor=white)](https://cachyos.org)
[![Niri](https://img.shields.io/badge/WM-Niri-6237D5?style=flat-square&logo=wayland&logoColor=white)](https://github.com/YaLTeR/niri)
[![Noctalia](https://img.shields.io/badge/Shell-Noctalia%205.1-25E075?style=flat-square)](https://noctalia.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-1E1E1E?style=flat-square)](LICENSE)

My dark **Material Design 2** rice for CachyOS and Arch Linux, inspired by ChromeOS: graphite surfaces, a green accent, Roboto typography, small corner radii, and soft shadows. Built around Niri's scrolling tiling layout and the Noctalia shell.

The `#25E075` accent is sampled from the green geometric wallpaper. It ties together the panel, text selection, active window border, terminal, and Telegram theme.

![Niri and Noctalia with Kitty running Fastfetch next to a GTK 4 app](assets/screenshots/desktop.png)

## What's included

| Component | Configuration |
|---|---|
| Windows | Niri: 4 px corner radius, 12 px gaps, 2 px focus ring, and shadows for elevation |
| Motion | Material 2 easing: windows grow from 90% and fade in, and close faster than they open |
| Desktop shell | Noctalia 5.1 with TOML configuration |
| Panel | At the top, flush with the screen edges, 40 px tall, 78% opacity |
| Workspaces | Minimal text labels without the active application's icon |
| Menus | Application grid, translucent control center, and background blur |
| Terminal | Kitty: Roboto Mono Nerd Font, 14 px padding, 82% opacity |
| Command shell | Fish + Pure: a single-line prompt with the current directory, Git status, and a red error indicator |
| GTK 3/4 | `adw-gtk3-dark`, Material 2 CSS in palette colors, Roboto 11, and Papirus Dark |
| Qt | qt6ct with the Noctalia palette, the Fusion style, Roboto, and Papirus Dark |
| Cursor | Bibata Modern Classic, size 20 |
| Utilities | Fastfetch, Btop, Cava, and Vim, all in palette colors |
| Media | mpv with the stock OSC in palette colors and shortcuts that also work on the Russian layout |
| Editors and chat | Zed and Discord themes from Noctalia community templates |
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

`Mod+Shift+T` switches between dark and light mode. Noctalia renders every color template again, so the shell, GTK, Qt, Kitty, Vim, mpv, and the rest follow. Fish shells that are already running keep the old colors until you open a new one.

## Requirements

This setup primarily targets CachyOS. On Arch Linux, you need compatible versions of Niri and Noctalia; you may need to install the `noctalia` package separately. The configuration uses Noctalia 5.1 with the `noctalia` command and a Niri build that supports `blur` and `background-effect`.

The `--install-packages` flag installs the following packages through `pacman`:

```text
niri noctalia kitty fish fish-pure-prompt fish-autopair
fastfetch btop cava mpv vim papirus-icon-theme adw-gtk-theme qt6ct
ttf-roboto ttf-roboto-mono-nerd xwayland-satellite
xdg-desktop-portal-gnome xdg-desktop-portal-gtk
```

Cloning requires `git`; the installer requires Bash, `curl`, and `tar` with `.xz` support. The cursor is downloaded from GitHub, so an internet connection is required even when installing without packages.

Install Helium, Thunar, and Telegram separately. Screen sharing needs `xdg-desktop-portal-gnome`: Niri's portal configuration routes screencasts through it. Qt applications pick up qt6ct from `QT_QPA_PLATFORMTHEME`, which Niri sets, so log in again after installing it.

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

- Copies the Niri, Noctalia, Kitty, Fish, Fastfetch, Btop, Cava, mpv, and GTK 3/4 configurations to `~/.config`.
- Installs `home/vimrc` as `~/.vimrc` and the Vim color scheme to `~/.vim/colors`.
- Downloads Bibata Modern Classic `v2.0.7` to `~/.icons` and makes it the default cursor in `~/.icons/default`.
- Writes `~/.local/state/noctalia/settings.toml` with the green palette, wallpaper, and color templates, and `~/.config/qt6ct/qt6ct.conf`.
- Sets the cursor, icons, and fonts through `gsettings`, so that portals and GTK dialogs match the rest of the desktop.
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
| `Mod+Shift+T` | Switch between dark and light mode |
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
| GTK control shapes | `config/noctalia/templates/gtk3-material2.css`, `gtk4-material2.css` |
| Terminal transparency and font | `config/kitty/kitty.conf` |
| Fish and Pure colors | `config/noctalia/templates/fish-colors.fish` |
| Pure prompt options | `config/fish/config.fish` |
| Vim colors | `config/noctalia/templates/vim-colors.vim` |
| Keyboard shortcuts and layouts | `config/niri/cfg/keybinds.kdl`, `config/niri/cfg/input.kdl` |
| Animations | `config/niri/cfg/animation.kdl` |
| Window rules and capture privacy | `config/niri/cfg/rules.kdl` |
| Monitors and scaling | `config/niri/cfg/display.kdl` |

To list monitor names and available modes, run:

```bash
niri msg outputs
```

The example monitor configuration in `display.kdl` is disabled with `/-`. The lock screen login box is tied to `eDP-1`: for another display, change `output`, the `lockscreen-login-box@eDP-1` identifier, and its entry in `widget_order`. You can adjust its position and size through the Noctalia interface.

The palette is fixed: changing the wallpaper does not replace the green accent. Noctalia applies colors to GTK, Qt, Kitty, Btop, Cava, and Niri through its built-in templates, to Zed and Discord through community templates, and to everything else through the user templates below. The final appearance depends on each application's theme support.

Running the installer again reapplies the palette, wallpaper, and settings from the repository. To keep your changes, run `./sync.sh` first (see [below](#keeping-the-repository-in-sync)) and move state changes into the [state template](state/noctalia/settings.toml.in) by hand.

### Color templates

The files in `config/noctalia/templates` are Noctalia user templates, registered in `config.toml` under `[theme.templates.user.<id>]`. Noctalia renders them on every palette or mode change: the GTK shapes (`material2.css`), Fish and Pure colors, the Vim color scheme, and mpv colors. Edit the template, not the rendered file, because the next render overwrites it. The rendered copies in the repository are the dark Material2-Green output, kept as a fallback for the first start.

To add a template of your own, put it next to the others and register it:

```toml
[theme.templates.user.example]
input_path = "$XDG_CONFIG_HOME/noctalia/templates/example.conf"
output_path = "~/.config/example/colors.conf"
```

Write paths with `$XDG_CONFIG_HOME` or `~`. Noctalia does not expand `$HOME`, and a template with it silently never renders. Colors look like `{{colors.primary.default.hex}}` (`hex_stripped`, `red`, `green`, and `blue` also work), and `{{ mode }}` gives `dark` or `light`. Noctalia derives the surface tokens itself; only the `terminal_*` tokens carry palette values unchanged. Apply changes with:

```bash
noctalia msg config-reload
noctalia msg templates-apply
```

### Zed and Discord

The Zed community template writes `~/.config/zed/themes/noctalia.json`. To follow the system mode, add this to `~/.config/zed/settings.json`:

```json
"theme": {
  "mode": "system",
  "light": "Noctalia Light",
  "dark": "Noctalia Dark"
}
```

The Discord template writes themes for Vesktop, Vencord, BetterDiscord, Equicord, WebCord, and other client mods into their theme folders; turn one on in the client's theme settings.

### Screen sharing privacy

Telegram windows and Noctalia notifications are blocked out from screencasts in `rules.kdl`: viewers of a shared screen see black boxes in their place. Screenshots still show them. Remove the `block-out-from "screencast"` rules if you want them visible.

## Keeping the repository in sync

`install.sh` copies files instead of linking them, so edits made in `~/.config` stay there. `sync.sh` copies them back:

```bash
./sync.sh --dry-run   # list the files that differ
./sync.sh             # copy them, then review with git diff
```

It only updates files the repository already tracks; new files still need a manual copy. It skips the `*.in` placeholders and the full configs that btop and cava write out. Rendered template output is copied only while Noctalia is in dark mode on Material2-Green, the state the fallbacks record.

## Telegram Desktop theme

Ready to import: [Material2-Green.tdesktop-theme](themes/telegram/Material2-Green.tdesktop-theme).

In Telegram, open **Settings → Chat Settings → theme menu → Choose from file**, select the archive, and apply it after previewing it. Menu labels may vary between client versions.

The theme includes dark message bubbles, green accents, and a subtle geometric chat background. Details and source files are in [themes/telegram](themes/telegram/README.md).

## Repository structure

```text
.
├── .github/workflows/         # CI: ShellCheck, niri validate, Telegram theme check
├── assets/                    # Screenshots, plus wallpapers from the previous setup
├── config/
│   ├── niri/                  # Compositor configuration, keybindings, and scripts
│   ├── noctalia/              # Panel, menus, palettes, wallpapers, and color templates
│   ├── kitty/                 # Terminal
│   ├── fish/                  # Shell settings and rendered colors
│   ├── gtk-3.0/               # GTK 3 styling
│   ├── gtk-4.0/               # GTK 4 styling
│   ├── qt6ct/                 # Qt settings template
│   ├── btop/                  # System monitor
│   ├── cava/                  # Audio visualizer
│   ├── mpv/                   # Media player
│   └── fastfetch/             # System information
├── home/                      # ~/.vimrc, Vim colors, and the default cursor
├── state/noctalia/            # Theme and wallpaper settings template
├── themes/telegram/           # Telegram theme and its source files
├── install.sh
├── sync.sh                    # Copies live edits back into the repository
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
