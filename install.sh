#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '[dotfiles] %s\n' "$*"
}

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        log "Missing dependency: $1"
        exit 1
    fi
}

timestamp() {
    date +"%Y%m%d%H%M%S"
}

link_file() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"

    if [ -L "$target" ]; then
        if [ "$(readlink "$target")" = "$source" ]; then
            log "Already linked: $target"
            return
        fi
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup="${target}.backup.$(timestamp)"
        mv "$target" "$backup"
        log "Existing $(basename "$target") moved to $backup"
    fi

    ln -s "$source" "$target"
    log "Linked $target -> $source"
}

has_include() {
    local include="$1"
    local includes
    includes="$(git config --global --get-all include.path 2>/dev/null || true)"
    grep -Fx "$include" <<<"$includes" >/dev/null 2>&1
}

ensure_include() {
    local include="$1"
    if has_include "$include"; then
        log "Git already includes $include"
    else
        git config --global --add include.path "$include"
        log "Added git include for $include"
    fi
}

drop_include() {
    local include="$1"
    if has_include "$include"; then
        git config --global --unset-all include.path "$include"
        log "Removed git include for $include"
    fi
}

configure_delta() {
    local delta_config="$1"
    if command -v delta >/dev/null 2>&1; then
        ensure_include "$delta_config"
        log "delta found; advanced diff pager enabled"
    else
        drop_include "$delta_config"
        log "delta not found; skipped advanced diff pager"
    fi
}

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

setup_zsh() {
    local repo_root="$1"
    local zsh_root="${repo_root}/zsh"

    if [ ! -d "$zsh_root" ]; then
        log "No zsh directory found; skipping shell setup"
        return
    fi

    local zdotdir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

    link_file "${zsh_root}/.zshenv" "$HOME/.zshenv"
    link_file "${zsh_root}/config" "$zdotdir"

    local plugin_list="${zsh_root}/config/plugins.list"
    if [ -f "$plugin_list" ]; then
        if [ "${DOTFILES_SKIP_ZSH_PLUGINS:-0}" != "0" ]; then
            log "DOTFILES_SKIP_ZSH_PLUGINS set; skipping plugin sync"
        elif ! command -v zsh >/dev/null 2>&1; then
            log "zsh not found; skipping plugin sync"
        else
            sync_zsh_plugins "$plugin_list"
        fi
    fi
}

main() {
    require_command git

    local repo_root
    repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    log "Installing dotfiles from ${repo_root}"

    local git_config="${repo_root}/git/.gitconfig"
    local git_ignore="${repo_root}/git/.gitignore_global"
    local git_message="${repo_root}/git/.gitmessage"
    local delta_config="${repo_root}/git/.gitconfig.delta"

    ensure_include "$git_config"
    configure_delta "$delta_config"

    link_file "$git_ignore" "$HOME/.gitignore_global"
    link_file "$git_message" "$HOME/.gitmessage"

    setup_zsh "$repo_root"

    log "Dotfiles installation complete"
    log "Update your name/email in ${git_config} if needed"
}

main "$@"
