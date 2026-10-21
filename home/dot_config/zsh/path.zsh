typeset -U path cdpath fpath manpath

# macOS: initialize Homebrew (Apple Silicon at /opt/homebrew, Intel at /usr/local)
if [[ "$OSTYPE" == darwin* ]]; then
	if [ -x /opt/homebrew/bin/brew ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [ -x /usr/local/bin/brew ]; then
		eval "$(/usr/local/bin/brew shellenv)"
	fi
fi

path=(
	"$HOME/.local/bin"
	"$HOME/bin"
	$path[@]
)

if [ -d "$ZSH_CONFIG_ROOT/functions" ]; then
	fpath=("$ZSH_CONFIG_ROOT/functions" $fpath[@])
fi

export PATH
