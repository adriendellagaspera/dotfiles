typeset plugin_file="${ZSH_CONFIG_ROOT}/plugins.list"
typeset plugin_store="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"

[ -d "$plugin_store" ] || mkdir -p "$plugin_store"

[ -f "$plugin_file" ] || return

typeset plugin
typeset -a plugins
while IFS= read -r plugin; do
	[[ -z "$plugin" || "$plugin" == \#* ]] && continue
	plugins+=("$plugin")
done <"$plugin_file"

for plugin in "${plugins[@]}"; do
	typeset name="${plugin##*/}"
	typeset dir="${plugin_store}/${name}"
	[ -d "$dir" ] || continue

	case "$name" in
		zsh-autosuggestions)
			source "$dir/zsh-autosuggestions.zsh"
			ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
			;;
		zsh-syntax-highlighting)
			source "$dir/zsh-syntax-highlighting.zsh"
			;;
		zsh-completions)
			fpath=("$dir/src" $fpath[@])
			;;
	esac
done

if command -v fzf >/dev/null 2>&1; then
	if [ -f "$HOME/.fzf.zsh" ]; then
		source "$HOME/.fzf.zsh"
	fi
fi

if (( $+functions[autosuggest-accept] )); then
	bindkey '^ ' autosuggest-accept
fi
