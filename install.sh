#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly TARGET_HOME="${HOME:?HOME is not set}"
readonly CONFIG_HOME="${XDG_CONFIG_HOME:-${TARGET_HOME}/.config}"
readonly STATE_HOME="${XDG_STATE_HOME:-${TARGET_HOME}/.local/state}"
readonly DATA_HOME="${XDG_DATA_HOME:-${TARGET_HOME}/.local/share}"
readonly RUN_ID="$(date +%Y%m%d-%H%M%S)"
readonly BACKUP_ROOT="${STATE_HOME}/gruvbox-noctalia-dotfiles/backups/${RUN_ID}"
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
    printf '[gruvbox-dots] %s\n' "$*"
}

die() {
    printf '[gruvbox-dots] error: %s\n' "$*" >&2
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
[[ -f "${SCRIPT_DIR}/assets/gruvbox-boxes.png" ]] || die "wallpaper asset is missing"
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

    relative="${target#${TARGET_HOME}/}"
    log "backup ~/${relative}"
    run mkdir -p -- "${BACKUP_ROOT}/$(dirname -- "$relative")"
    run cp -a -- "$target" "${BACKUP_ROOT}/${relative}"
}

install_tree() {
    local source="$1"
    local target="$2"

    [[ -d "$source" ]] || die "missing source directory: $source"
    backup_target "$target"
    log "install ${target#${TARGET_HOME}/}"
    run mkdir -p -- "$target"
    run cp -a -- "${source}/." "${target}/"
}

install_file() {
    local source="$1"
    local target="$2"

    [[ -f "$source" ]] || die "missing source file: $source"
    backup_target "$target"
    log "install ${target#${TARGET_HOME}/}"
    run install -Dm644 -- "$source" "$target"
}

install_noctalia_state() {
    local source="${SCRIPT_DIR}/state/noctalia/settings.toml.in"
    local target="${STATE_HOME}/noctalia/settings.toml"
    local rendered

    backup_target "$target"
    log "render ${target#${TARGET_HOME}/}"

    if $DRY_RUN; then
        printf '  + render %q with HOME=%q\n' "$source" "$TARGET_HOME"
        return
    fi

    rendered="$(mktemp)"
    [[ -n "$rendered" && -f "$rendered" ]] || die "failed to create temporary file"
    trap 'rm -f -- "${rendered:-}"' RETURN

    while IFS= read -r line || [[ -n "$line" ]]; do
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

if $INSTALL_PACKAGES; then
    command -v pacman >/dev/null 2>&1 || die "--install-packages requires pacman"
    log "installing packages"
    run sudo pacman -S --needed \
        niri noctalia kitty fish fish-pure-prompt fish-autopair \
        fastfetch btop vim papirus-icon-theme adw-gtk-theme
fi

for app in niri noctalia kitty fish fastfetch btop gtk-3.0 gtk-4.0; do
    install_tree "${SCRIPT_DIR}/config/${app}" "${CONFIG_HOME}/${app}"
done

install_file "${SCRIPT_DIR}/home/vimrc" "${TARGET_HOME}/.vimrc"
install_file "${SCRIPT_DIR}/assets/gruvbox-boxes.png" "${DATA_HOME}/backgrounds/gruvbox-boxes.png"
install_cursor
install_noctalia_state

if $DRY_RUN; then
    log "dry run complete; no files changed"
else
    log "installation complete"
    log "backup: ${BACKUP_ROOT}"
    log "log out and start a new Niri session to apply every setting"
fi
