# ls: --color=auto (GNU coreutils) vs -G (BSD/macOS)
if [[ "$OSTYPE" == darwin* ]]; then
	alias ls='ls -G'
else
	alias ls='ls --color=auto'
fi
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

# Clipboard: normalize across macOS / Linux (Wayland + X11)
if [[ "$OSTYPE" == darwin* ]]; then
	alias copy='pbcopy'
	alias paste='pbpaste'
elif command -v wl-copy >/dev/null 2>&1; then
	alias copy='wl-copy'
	alias paste='wl-paste'
elif command -v xclip >/dev/null 2>&1; then
	alias copy='xclip -selection clipboard'
	alias paste='xclip -selection clipboard -o'
elif command -v xsel >/dev/null 2>&1; then
	alias copy='xsel --clipboard --input'
	alias paste='xsel --clipboard --output'
fi

# open: use xdg-open on Linux
if [[ "$OSTYPE" != darwin* ]] && command -v xdg-open >/dev/null 2>&1; then
	alias open='xdg-open'
fi
