export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less -F -X}"
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="$LANG"

export GOPATH="${GOPATH:-$HOME/go}"
export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"

path=("$PNPM_HOME" "$GOPATH/bin" "$CARGO_HOME/bin" $path[@])
