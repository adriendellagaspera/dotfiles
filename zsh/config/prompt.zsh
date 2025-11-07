setopt PROMPT_SUBST

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' unstagedstr '✚'
zstyle ':vcs_info:git*' stagedstr '●'
zstyle ':vcs_info:git*' formats 'on %F{magenta}%b%f %F{yellow}%u%f%F{green}%c%f'
zstyle ':vcs_info:*' actionformats '%F{red}%a%f'

vcs_info_precmd() {
	vcs_info
}

add-zsh-hook precmd vcs_info_precmd

_prompt_exitstatus() {
	(( $? == 0 )) && return
	printf '%F{red}%d%f ' "$?"
}

PROMPT='$(_prompt_exitstatus)%F{cyan}%n%f@%F{yellow}%m%f %F{blue}%1~%f ${vcs_info_msg_0_}%F{green}$%f '
RPROMPT='%F{240}%*%f'
