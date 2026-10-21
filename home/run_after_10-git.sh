#!/usr/bin/env bash
set -euo pipefail
config="$HOME/.config/git/gitconfig"
delta_config="$HOME/.config/git/gitconfig.delta"
# --fixed-value avoids treating paths as regular expressions.
ensure_include() {
  if ! git config --global --fixed-value --get-all include.path "$1" >/dev/null; then
    git config --global --add include.path "$1"
  fi
}
ensure_include "$config"
if command -v delta >/dev/null 2>&1; then
  ensure_include "$delta_config"
elif git config --global --fixed-value --get-all include.path "$delta_config" >/dev/null; then
  git config --global --fixed-value --unset-all include.path "$delta_config"
fi
