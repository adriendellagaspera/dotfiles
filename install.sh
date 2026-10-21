#!/usr/bin/env bash
# Entry point for local checkouts, Codespaces and VS Code Dev Containers.
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! command -v chezmoi >/dev/null 2>&1; then
  command -v curl >/dev/null 2>&1 || { printf '%s\n' 'curl is required to install chezmoi' >&2; exit 1; }
  installer="$(mktemp)"
  trap 'rm -f "$installer"' EXIT
  curl --fail --silent --show-error --location https://get.chezmoi.io -o "$installer"
  sh "$installer" -b "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
fi
exec chezmoi --source "$repo_root" apply "$@"
