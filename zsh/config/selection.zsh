
# macOS-style command-line selection for ZLE
# Uses the macOS pbcopy command for clipboard operations.

# Match the working ~/.zshrc: use Emacs editing and explicit word navigation.
bindkey -e
bindkey -M emacs $'\e[1;3D' backward-word
bindkey -M emacs $'\e[1;3C' forward-word

# Create a dedicated keymap for active selections.
bindkey -N macos-selection

# Enable selection highlighting.
zle_highlight+=(region:standout)

# Extend selection using a native movement widget.
function macos-selection-move() {
  if (( ! REGION_ACTIVE )); then
    zle set-mark-command
  fi

  zle -K macos-selection
  zle "${WIDGET#macos-select-}"
}

# Select the entire editable buffer.
function macos-select-all() {
  MARK=0
  CURSOR=${#BUFFER}
  REGION_ACTIVE=1
  zle -K macos-selection
}

# Delete the currently selected region.
function macos-selection-delete() {
  zle kill-region
  zle -K main
}

# Handle input while a selection is active.
function macos-selection-input() {
  local input=$KEYS

  if [[ $input == [[:print:]] ]]; then
    zle kill-region
  else
    zle deactivate-region
  fi

  zle -K main
  zle -U "$input"
}

# Register the selection widgets.
zle -N macos-select-all
zle -N macos-selection-delete
zle -N macos-selection-input

# Unhandled keys return to the normal keymap.
bindkey -M macos-selection -R '^@'-'^?' macos-selection-input

# Register character and word selection movements.
for movement in \
  backward-char forward-char \
  backward-word forward-word
do
  zle -N "macos-select-$movement" macos-selection-move
done

# Extend selection to the beginning of the command.
function macos-select-beginning-of-buffer() {
  (( REGION_ACTIVE )) || zle set-mark-command
  CURSOR=0
  zle -K macos-selection
}

# Extend selection to the end of the command.
function macos-select-end-of-buffer() {
  (( REGION_ACTIVE )) || zle set-mark-command
  CURSOR=${#BUFFER}
  zle -K macos-selection
}

# Register command boundary selection widgets.
zle -N macos-select-beginning-of-buffer
zle -N macos-select-end-of-buffer

# Bind selection shortcuts in both keymaps.
for keymap in emacs macos-selection; do
  bindkey -M "$keymap" $'\e[1;2D' macos-select-backward-char
  bindkey -M "$keymap" $'\e[1;2C' macos-select-forward-char

  bindkey -M "$keymap" $'\e[1;4D' macos-select-backward-word
  bindkey -M "$keymap" $'\e[1;4C' macos-select-forward-word

  bindkey -M "$keymap" $'\e[1;10D' macos-select-beginning-of-buffer
  bindkey -M "$keymap" $'\e[1;10C' macos-select-end-of-buffer

  bindkey -M "$keymap" $'\e[97;9u' macos-select-all
done

# Delete the selection using Backspace or Delete.
bindkey -M macos-selection '^?' macos-selection-delete
bindkey -M macos-selection '^H' macos-selection-delete
bindkey -M macos-selection $'\e[3~' macos-selection-delete


# Copy the selected command text without clearing the selection.
function macos-copy-selection() {
  (( REGION_ACTIVE )) || return 0

  local start=$(( MARK < CURSOR ? MARK : CURSOR ))
  local end=$(( MARK > CURSOR ? MARK : CURSOR ))

  # ZLE cursor offsets are zero-based; zsh string indices are one-based.
  local selected=${BUFFER[$(( start + 1 )),$end]}

  print -rn -- "$selected" | pbcopy

  # Keep the selection active for further editing.
  REGION_ACTIVE=1
  zle -K macos-selection
}

zle -N macos-copy-selection



# Replace the active selection with bracketed-paste content.
function macos-selection-paste() {
  local pasted

  # Read the entire paste without inserting it yet.
  zle .bracketed-paste pasted || return

  # Remove the selected text.
  if (( REGION_ACTIVE )); then
    zle kill-region
  fi

  # Insert the pasted text literally, preserving newlines.
  LBUFFER+="$pasted"

  # Return to normal editing mode.
  REGION_ACTIVE=0
  zle -K main
}

# Register the selection-aware paste widget.
zle -N macos-selection-paste

# Intercept bracketed paste only when a selection is active.
bindkey -M macos-selection $'\e[200~' macos-selection-paste




# Cut the active ZLE selection to the macOS clipboard.
function macos-cut-selection() {
  (( REGION_ACTIVE )) || return 0

  zle kill-region
  print -rn -- "$CUTBUFFER" | pbcopy

  REGION_ACTIVE=0
  zle -K main
}

zle -N macos-cut-selection


# Insert a newline without executing the command.
function macos-insert-newline() {
  if (( REGION_ACTIVE )); then
    zle kill-region
    REGION_ACTIVE=0
  fi

  zle -K main
  LBUFFER+=$'\n'
}

zle -N macos-insert-newline

# Handle modified Enter keys.
for keymap in emacs macos-selection; do
  bindkey -M "$keymap" $'\e[27;2;13~' macos-insert-newline
  bindkey -M "$keymap" $'\e[27;5;13~' accept-line
done


# Register clipboard shortcuts in both keymaps.
for keymap in emacs macos-selection; do
  bindkey -M "$keymap" $'\e[99;9u' macos-copy-selection
  bindkey -M "$keymap" $'\e[120;9u' macos-cut-selection
done
