#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT
export HOME="$test_root/home"
unset XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_CACHE_HOME ZDOTDIR
export DOTFILES_SKIP_ZSH_PLUGINS=1
mkdir -p "$HOME"
git config --global user.name 'Existing User'
git config --global user.email existing@example.com
for iteration in 1 2; do
  bash "$repo_root/install.sh"
  test "$(git config --global user.name)" = 'Existing User'
  test "$(git config --global user.email)" = existing@example.com
  test "$(git config --global --get-all include.path | wc -l | tr -d ' ')" -le 2
  test -f "$HOME/.zshenv"
  test ! -L "$HOME/.zshenv"
  test -f "$HOME/.config/zsh/.zshrc"
  test -d "$HOME/.config/zsh/local"
  test ! -e "$HOME/README.md"
  test ! -e "$HOME/packages"
  test "$(git config --global --includes alias.current)" = 'branch --show-current'
done
printf 'export DOTFILES_LOCAL_TEST=preserved\n' > "$HOME/.config/zsh/local/test.zsh"
bash "$repo_root/install.sh"
zsh -ic '[[ $DOTFILES_LOCAL_TEST == preserved ]] && alias gs' </dev/null
if [ "$(uname -s)" = Darwin ]; then
  test -f "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
else
  test ! -e "$HOME/Library"
fi
# Check migration against a complete legacy fixture before applying again.
legacy_root="$test_root/legacy"
mkdir -p "$legacy_root/zsh/config/local" "$legacy_root/git"
printf '# legacy\n' > "$legacy_root/zsh/.zshenv"
printf 'local override\n' > "$legacy_root/zsh/config/local/keep.zsh"
printf '[user]\n name = Legacy\n' > "$legacy_root/git/.gitconfig"
printf '# ignore\n' > "$legacy_root/git/.gitignore_global"
printf '# message\n' > "$legacy_root/git/.gitmessage"
rm "$HOME/.zshenv" "$HOME/.gitignore_global" "$HOME/.gitmessage"
rm -rf "$HOME/.config/zsh"
ln -s "$legacy_root/zsh/.zshenv" "$HOME/.zshenv"
ln -s "$legacy_root/zsh/config" "$HOME/.config/zsh"
ln -s "$legacy_root/git/.gitignore_global" "$HOME/.gitignore_global"
ln -s "$legacy_root/git/.gitmessage" "$HOME/.gitmessage"
git config --global --add include.path "$legacy_root/git/.gitconfig"
bash "$repo_root/scripts/migrate-legacy.sh" "$legacy_root"
test ! -L "$HOME/.config/zsh"
test "$(cat "$HOME/.config/zsh/local/keep.zsh")" = 'local override'
if git config --global --get-all include.path | grep -F "$legacy_root"; then exit 1; fi
bash "$repo_root/install.sh"
test -f "$HOME/.config/zsh/.zshrc"
test -f "$HOME/.config/zsh/local/keep.zsh"
