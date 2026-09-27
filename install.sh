#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly SCRIPT_DIR
readonly TARGET_HOME="${HOME:?HOME is not set}"
readonly CONFIG_HOME="${XDG_CONFIG_HOME:-${TARGET_HOME}/.config}"
readonly STATE_HOME="${XDG_STATE_HOME:-${TARGET_HOME}/.local/state}"
RUN_ID="$(date +%Y%m%d-%H%M%S)"
readonly RUN_ID
readonly BACKUP_ROOT="${STATE_HOME}/material2-noctalia-dotfiles/backups/${RUN_ID}"
readonly BIBATA_VERSION="v2.0.7"
readonly BIBATA_ARCHIVE="Bibata-Modern-Classic.tar.xz"
readonly BIBATA_URL="https://github.com/ful1e5/Bibata_Cursor/releases/download/${BIBATA_VERSION}/${BIBATA_ARCHIVE}"

DRY_RUN=false
INSTALL_PACKAGES=false

usage() {
    cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --dry-run           Show what would be installed without changing files
  --install-packages  Install required packages with pacman before dotfiles
  -h, --help          Show this help
EOF
}

log() {
    printf '[material2-dots] %s\n' "$*"
}

die() {
    printf '[material2-dots] error: %s\n' "$*" >&2
    exit 1
}

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        --install-packages) INSTALL_PACKAGES=true ;;
        -h|--help) usage; exit 0 ;;
        *) die "unknown option: $arg" ;;
    esac
done

[[ -d "${SCRIPT_DIR}/config" ]] || die "config directory is missing"
[[ "$TARGET_HOME" = /* && "$TARGET_HOME" != "/" ]] || die "unsafe HOME: $TARGET_HOME"

run() {
    if $DRY_RUN; then
        printf '  + '
        printf '%q ' "$@"
        printf '\n'
    else
        "$@"
    fi
}

backup_target() {
    local target="$1"
    local relative

    [[ "$target" == "${TARGET_HOME}/"* ]] || die "refusing to back up outside HOME: $target"
    [[ -e "$target" || -L "$target" ]] || return 0

    relative="${target#"${TARGET_HOME}"/}"
    log "backup ~/${relative}"
    run mkdir -p -- "${BACKUP_ROOT}/$(dirname -- "$relative")"
    run cp -a -- "$target" "${BACKUP_ROOT}/${relative}"
}

install_tree() {
    local source="$1"
    local target="$2"

    [[ -d "$source" ]] || die "missing source directory: $source"
    backup_target "$target"
    log "install ${target#"${TARGET_HOME}"/}"
    run mkdir -p -- "$target"
    # Replace old file symlinks (not their system-wide targets), after backup.
    run cp -a --remove-destination -- "${source}/." "${target}/"
}

install_file() {
    local source="$1"
    local target="$2"

    [[ -f "$source" ]] || die "missing source file: $source"
    backup_target "$target"
    log "install ${target#"${TARGET_HOME}"/}"
    run install -Dm644 -- "$source" "$target"
}

render_file() {
    local source="$1"
    local target="$2"
    local rendered
    local line
    local config_toml

    [[ -f "$source" ]] || die "missing source file: $source"
    backup_target "$target"
    log "render ${target#"${TARGET_HOME}"/}"

    if $DRY_RUN; then
        printf '  + render %q with CONFIG_HOME=%q\n' "$source" "$CONFIG_HOME"
        return
    fi

    rendered="$(mktemp)"
    [[ -n "$rendered" && -f "$rendered" ]] || die "failed to create temporary file"
    trap 'rm -f -- "${rendered:-}"' RETURN

    # Escape the config directory as a TOML double-quoted string; INI files
    # get the same value, which is unchanged for ordinary paths.
    config_toml="${CONFIG_HOME//\\/\\\\}"
    config_toml="${config_toml//\"/\\\"}"
    while IFS= read -r line || [[ -n "$line" ]]; do
        line="${line//@CONFIG_HOME@/${config_toml}}"
        printf '%s\n' "${line//@HOME@/${TARGET_HOME}}"
    done < "$source" > "$rendered"

    mkdir -p -- "$(dirname -- "$target")"
    install -m644 -- "$rendered" "$target"
    rm -f -- "$rendered"
    trap - RETURN
}

install_cursor() {
    local target="${TARGET_HOME}/.icons/Bibata-Modern-Classic"
    local temp_dir
    local extracted

    backup_target "$target"
    log "install .icons/Bibata-Modern-Classic from ${BIBATA_VERSION}"

    if $DRY_RUN; then
        printf '  + download %s\n' "$BIBATA_URL"
        printf '  + extract Bibata-Modern-Classic into %q\n' "${TARGET_HOME}/.icons"
        return
    fi

    command -v curl >/dev/null 2>&1 || die "curl is required to download Bibata"
    command -v tar >/dev/null 2>&1 || die "tar is required to extract Bibata"

    temp_dir="$(mktemp -d "${TMPDIR:-/tmp}/bibata-install.XXXXXX")"
    [[ -n "$temp_dir" && -d "$temp_dir" && ! -L "$temp_dir" ]] || die "failed to create a safe temporary directory"

    curl -fL --retry 3 --output "${temp_dir}/${BIBATA_ARCHIVE}" "$BIBATA_URL"
    tar -xJf "${temp_dir}/${BIBATA_ARCHIVE}" -C "$temp_dir"

    extracted="${temp_dir}/Bibata-Modern-Classic"
    [[ -d "$extracted" && ! -L "$extracted" && -f "$extracted/index.theme" ]] || die "downloaded Bibata archive has an unexpected layout"

    mkdir -p -- "${TARGET_HOME}/.icons"
    cp -a -- "$extracted" "${TARGET_HOME}/.icons/"

    [[ "$temp_dir" == "${TMPDIR:-/tmp}/bibata-install."* && -d "$temp_dir" && ! -L "$temp_dir" ]] || die "refusing to clean an unsafe temporary path"
    rm -rf -- "$temp_dir"
}

apply_interface_settings() {
    local schema="org.gnome.desktop.interface"

    # GTK apps read these instead of settings.ini when a settings daemon or
    # portal is running, and tools like nwg-look overwrite them.
    if ! command -v gsettings >/dev/null 2>&1; then
        log "gsettings not found, skip ${schema}"
        return 0
    fi

    log "set cursor, icon and font keys in ${schema}"
    run gsettings set "$schema" cursor-theme 'Bibata-Modern-Classic'
    run gsettings set "$schema" cursor-size 20
    run gsettings set "$schema" icon-theme 'Papirus-Dark'
    run gsettings set "$schema" font-name 'Roboto 11'
    run gsettings set "$schema" monospace-font-name 'RobotoMono Nerd Font 11'
}

if $INSTALL_PACKAGES; then
    command -v pacman >/dev/null 2>&1 || die "--install-packages requires pacman"
    log "installing packages"
    run sudo pacman -S --needed \
        niri noctalia kitty fish fish-pure-prompt fish-autopair \
        fastfetch btop cava mpv vim papirus-icon-theme adw-gtk-theme qt6ct \
        ttf-roboto ttf-roboto-mono-nerd xwayland-satellite \
        xdg-desktop-portal-gnome xdg-desktop-portal-gtk
fi

for app in niri noctalia kitty fish fastfetch btop cava mpv gtk-3.0 gtk-4.0; do
    install_tree "${SCRIPT_DIR}/config/${app}" "${CONFIG_HOME}/${app}"
done

install_file "${SCRIPT_DIR}/home/vimrc" "${TARGET_HOME}/.vimrc"
# Rendered fallback; Noctalia rewrites it from its vim template.
install_file "${SCRIPT_DIR}/home/vim/colors/noctalia.vim" "${TARGET_HOME}/.vim/colors/noctalia.vim"
install_cursor
# XWayland and toolkits that ignore XCURSOR_THEME fall back to the "default" theme.
install_file "${SCRIPT_DIR}/home/icons/default/index.theme" "${TARGET_HOME}/.icons/default/index.theme"
apply_interface_settings
render_file "${SCRIPT_DIR}/state/noctalia/settings.toml.in" "${STATE_HOME}/noctalia/settings.toml"
render_file "${SCRIPT_DIR}/config/qt6ct/qt6ct.conf.in" "${CONFIG_HOME}/qt6ct/qt6ct.conf"

if $DRY_RUN; then
    log "dry run complete; no files changed"
else
    log "installation complete"
    log "backup: ${BACKUP_ROOT}"
    log "log out and start a new Niri session to apply every setting"
fi
