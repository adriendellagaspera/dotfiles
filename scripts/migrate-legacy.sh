#!/usr/bin/env bash
set -euo pipefail
legacy_root="${1:?Usage: migrate-legacy.sh /absolute/path/to/old/dotfiles}"
legacy_root="$(cd "$legacy_root" && pwd)"
backup_root="$(mktemp -d "$HOME/dotfiles-backup.XXXXXX")"
backup_link() {
  local target="$1" source="$2" name="$3"
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    # Copy through the link first: retain configuration and local overrides.
    cp -RL "$target" "$backup_root/$name"
    rm "$target"
  fi
}
backup_link "$HOME/.zshenv" "$legacy_root/zsh/.zshenv" zshenv
backup_link "$HOME/.gitignore_global" "$legacy_root/git/.gitignore_global" gitignore_global
backup_link "$HOME/.gitmessage" "$legacy_root/git/.gitmessage" gitmessage
backup_link "$HOME/.config/zsh" "$legacy_root/zsh/config" zsh
backup_link "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty" "$legacy_root/ghostty/config.ghostty" ghostty
if [ -d "$backup_root/zsh/local" ]; then
  mkdir -p "$HOME/.config/zsh"
  cp -R "$backup_root/zsh/local" "$HOME/.config/zsh/"
fi
for config in "$legacy_root/git/.gitconfig" "$legacy_root/git/.gitconfig.delta"; do
  if git config --global --fixed-value --get-all include.path "$config" >/dev/null; then
    git config --global --fixed-value --unset-all include.path "$config"
  fi
done
printf 'Legacy configuration backed up to %s\n' "$backup_root"
