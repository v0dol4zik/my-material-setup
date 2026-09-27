#!/usr/bin/env bash

# Copy live changes back into the repository: the reverse of install.sh.
# Only files the repository already tracks are copied, so caches, backups and
# private app state never end up here. New files still need a manual copy.

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly SCRIPT_DIR
readonly TARGET_HOME="${HOME:?HOME is not set}"
readonly CONFIG_HOME="${XDG_CONFIG_HOME:-${TARGET_HOME}/.config}"
readonly STATE_HOME="${XDG_STATE_HOME:-${TARGET_HOME}/.local/state}"
readonly NOCTALIA_STATE="${STATE_HOME}/noctalia/settings.toml"

DRY_RUN=false

usage() {
    cat <<'EOF'
Usage: ./sync.sh [options]

Options:
  --dry-run  List the files that would be copied without changing them
  -h, --help Show this help
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
        -h|--help) usage; exit 0 ;;
        *) die "unknown option: $arg" ;;
    esac
done

command -v git >/dev/null 2>&1 || die "git is required"

# Map a tracked repository path to its live location; empty means "skip".
live_path() {
    case "$1" in
        # Rendered by install.sh from placeholders, never copied back.
        *.in) ;;
        # btop and cava write out every default; the repository keeps only
        # the options that differ.
        config/btop/btop.conf|config/cava/config) ;;
        config/*) printf '%s\n' "${CONFIG_HOME}/${1#config/}" ;;
        home/vimrc) printf '%s\n' "${TARGET_HOME}/.vimrc" ;;
        home/*) printf '%s\n' "${TARGET_HOME}/.${1#home/}" ;;
    esac
}

# Files Noctalia renders from its templates. The repository keeps the dark
# Material2-Green render as a fallback, so skip them in any other state.
is_rendered() {
    case "$1" in
        config/*/noctalia.css|config/*/noctalia.conf|config/*/noctalia.kdl) return 0 ;;
        config/btop/themes/noctalia.theme|config/cava/themes/noctalia) return 0 ;;
        config/gtk-*/material2.css|config/fish/conf.d/noctalia-colors.fish) return 0 ;;
        config/helium-material2/manifest.json) return 0 ;;
        home/vim/colors/noctalia.vim) return 0 ;;
    esac
    return 1
}

rendered_ok=false
if [[ -f "$NOCTALIA_STATE" ]] \
    && grep -Eq '^mode = "dark"$' "$NOCTALIA_STATE" \
    && grep -Eq '^custom_palette = "Material2-Green"$' "$NOCTALIA_STATE"; then
    rendered_ok=true
else
    log "Noctalia is not on dark Material2-Green: rendered files stay as they are"
fi

copied=0
while IFS= read -r -d '' path; do
    live="$(live_path "$path")"
    [[ -n "$live" && -f "$live" ]] || continue
    if is_rendered "$path" && ! $rendered_ok; then
        continue
    fi
    cmp -s -- "$live" "${SCRIPT_DIR}/${path}" && continue

    log "update ${path}"
    copied=$((copied + 1))
    $DRY_RUN || cp -- "$live" "${SCRIPT_DIR}/${path}"
done < <(git -C "$SCRIPT_DIR" ls-files -z -- config home)

if ((copied == 0)); then
    log "repository already matches the live files"
elif $DRY_RUN; then
    log "dry run: ${copied} file(s) differ"
else
    log "${copied} file(s) updated; review with: git diff"
fi
