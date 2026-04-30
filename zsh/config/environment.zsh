export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less -F -X}"
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="$LANG"

export GOPATH="${GOPATH:-$HOME/go}"
export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"

# Only prepend tool paths when the directory actually exists
[[ -d "$PNPM_HOME" ]]      && path=("$PNPM_HOME" $path[@])
[[ -d "$GOPATH/bin" ]]     && path=("$GOPATH/bin" $path[@])
[[ -d "$CARGO_HOME/bin" ]] && path=("$CARGO_HOME/bin" $path[@])
