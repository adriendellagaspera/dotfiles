setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt HIST_VERIFY
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt COMPLETE_ALIASES
setopt NOMATCH

export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
export HISTSIZE=100000
export SAVEHIST=200000
[ -d "${HISTFILE:h}" ] || mkdir -p "${HISTFILE:h}"

bindkey -e
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
