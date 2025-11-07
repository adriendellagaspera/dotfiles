# shellcheck shell=zsh

setopt EXTENDED_GLOB

typeset config_root="${${(%):-%N}:A:h}"
export ZSH_CONFIG_ROOT="$config_root"

autoload -Uz add-zsh-hook colors vcs_info
colors

for module in path environment options completion aliases tools prompt plugins; do
	typeset file="${config_root}/${module}.zsh"
	[ -f "$file" ] && source "$file"
done

# Load any optional overrides placed in ~/.config/zsh/local/*.zsh
typeset local_dir="${config_root}/local"
if [ -d "$local_dir" ]; then
	for file in "${local_dir}"/*.zsh(.N); do
		source "$file"
	done
fi
