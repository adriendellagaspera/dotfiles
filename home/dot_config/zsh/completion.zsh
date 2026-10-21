autoload -Uz compinit bashcompinit

if [ ! -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" ]; then
	mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
fi

compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{blue}%d%f'

if command -v bash >/dev/null 2>&1; then
	bashcompinit
fi
