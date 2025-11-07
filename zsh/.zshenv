# Keep .zshenv tiny: it runs for every zsh invocation, interactive or not.

export DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/dotfiles}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"

[ -d "$ZDOTDIR" ] || mkdir -p "$ZDOTDIR"
