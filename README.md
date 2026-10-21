# Dotfiles

Git and zsh configuration for local machines and disposable environments.

## Install

```sh
./install.sh
```

The installer adds `git/.gitconfig` to the global Git configuration, links the
global ignore file and commit template, and links `zsh/.zshenv` and `zsh/config`
into the home directory. Existing files at those paths are backed up with a
timestamp. Re-running the installer updates the links and optional zsh plugins.

Edit `git/.gitconfig` to set your Git name and email. The defaults are
placeholders. Local zsh overrides belong in `zsh/config/local/`, which is
excluded from Git.

If `delta` is installed, the installer includes `git/.gitconfig.delta`; otherwise
it removes that include. If `zsh` is installed, it syncs plugins listed in
`zsh/config/plugins.list`. Set `DOTFILES_SKIP_ZSH_PLUGINS=1` to skip that step.

Configuration lives in `git/` and `zsh/config/`; inspect those files for the
current aliases and shell behavior. Optional package lists are in `packages/`.

## Ghostty and macOS command-line selection

On macOS, `./install.sh` also links `ghostty/config.ghostty` to
`~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`, backing up
an existing file using the same timestamp convention. The existing zsh directory
link includes `selection.zsh`; `.zshrc` loads it after plugins and before local
overrides, only on macOS. Restart zsh and reload Ghostty's configuration afterward.
The installer replaces the zsh configuration directory with a symlink after backing
it up; move any personal settings you want to retain into `zsh/config/local/`.
The supplied personal `~/.zshrc` is not installed wholesale: existing repository
modules keep their settings, and its older selection definitions are superseded
by the selection module.

| Shortcut | Behavior |
| --- | --- |
| Option+Left/Right | Move by word |
| Cmd+Left/Right | Move to command boundaries |
| Option+Backspace / Cmd+Backspace | Delete previous word / text before cursor |
| Shift+Left/Right | Extend selection by character |
| Option+Shift+Left/Right | Extend selection by word |
| Cmd+Shift+Left/Right | Extend selection to command boundaries |
| Cmd+A | Select the editable command |
| Cmd+C / Cmd+X | Copy / cut the ZLE selection using macOS `pbcopy` |
| Cmd+V | Paste; replace the active ZLE selection, preserving newlines |
| Cmd+Shift+C | Copy Ghostty's terminal selection |
| Shift+Enter / Ctrl+Enter | Insert newline / execute command |

Mouse-selected terminal text is copied automatically and stays highlighted.
Cmd+C without a ZLE selection does nothing; use Ctrl+C to interrupt a command.
The module uses Emacs editing mode, as in the working personal configuration.
Modified Enter bindings consume Ghostty's `ESC [ 27;2;13~` and
`ESC [ 27;5;13~` sequences. Full keyboard and clipboard behavior should be checked
in an interactive Ghostty window after installation.
