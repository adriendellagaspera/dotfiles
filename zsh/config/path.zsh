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
	"$DOTFILES_ROOT/bin"
	$path[@]
)

if [ -d "$DOTFILES_ROOT/zsh/functions" ]; then
	fpath=("$DOTFILES_ROOT/zsh/functions" $fpath[@])
fi

export PATH
