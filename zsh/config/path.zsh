typeset -U path cdpath fpath manpath

path=(
	"$HOME/.local/bin"
	"$HOME/bin"
	"$DOTFILES_ROOT/bin"
	"$path[@]"
)

if [ -d "$DOTFILES_ROOT/zsh/functions" ]; then
	fpath=("$DOTFILES_ROOT/zsh/functions" $fpath[@])
fi

export PATH
