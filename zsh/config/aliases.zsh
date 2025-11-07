alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias gs='git status -sb'
alias gl='git lg'
alias gp='git push'
alias gpl='git pull'
alias ga='git add'

alias reload!='exec zsh'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'

if command -v bat >/dev/null 2>&1; then
	alias cat='bat --paging=never'
fi
