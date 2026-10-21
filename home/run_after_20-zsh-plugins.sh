#!/usr/bin/env bash
set -euo pipefail
log() { printf '[dotfiles] %s\n' "$*"; }
sync_zsh_plugins() {
    local list_file="$1"
    local plugins_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
    mkdir -p "$plugins_dir"

    while IFS= read -r slug; do
        [[ -z "$slug" || "$slug" == \#* ]] && continue

        local name="${slug##*/}"
        local dest="${plugins_dir}/${name}"

        if [ -d "$dest/.git" ]; then
            if git -C "$dest" pull --ff-only --quiet; then
                log "Updated ${slug}"
            else
                log "Warning: failed to update ${slug} (leave existing copy as-is)"
            fi
        else
            if git clone --depth 1 "https://github.com/${slug}.git" "$dest" >/dev/null 2>&1; then
                log "Cloned ${slug}"
            else
                log "Warning: failed to clone ${slug} (will retry next install)"
            fi
        fi
    done <"$list_file"
}

mkdir -p "$HOME/.config/zsh/local"
if [ "${DOTFILES_SKIP_ZSH_PLUGINS:-0}" = 0 ] && command -v zsh >/dev/null 2>&1; then
  sync_zsh_plugins "$HOME/.config/zsh/plugins.list"
fi
