# shellcheck shell=zsh

if command -v eza >/dev/null 2>&1; then
	alias ls='eza --group-directories-first --icons=auto'
	alias ll='eza -alF --git --group-directories-first --icons=auto'
	alias la='eza -a --group-directories-first --icons=auto'
	alias tree='eza --tree --icons=auto'
fi

if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init zsh)"
	alias j='z'
fi
