# Dotfiles

Git, Zsh and macOS Ghostty configuration managed by chezmoi.
The GitHub repository is `adriendellagaspera/dotfiles` (without a leading dot).

## New machine

Install [chezmoi](https://www.chezmoi.io/install/), then preview and apply:

```sh
chezmoi init https://github.com/adriendellagaspera/dotfiles.git
chezmoi diff
chezmoi apply
```

Or clone this repository and run `bash install.sh`. The wrapper installs chezmoi
with its official installer if missing, then applies this checkout. It accepts
chezmoi apply options, e.g. `bash install.sh --dry-run --verbose`.
No packages are installed, no login shell is changed, and no VS Code settings
are overwritten. The only implicit download besides chezmoi is optional Zsh
plugins; use `DOTFILES_SKIP_ZSH_PLUGINS=1` for offline/minimal environments.

The managed configuration paths are `~/.config/zsh`, `~/.config/git`,
`~/.zshenv`, `~/.gitignore_global`, `~/.gitmessage`, and on macOS
`~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`.
These paths deliberately remain fixed even with a custom XDG_CONFIG_HOME.
An explicitly set ZDOTDIR still takes precedence; unset it to use this Zsh setup.
Local overrides in `~/.config/zsh/local/*.zsh` are never managed or deleted.
Git configuration is included from your existing global configuration, preserving
other settings and your name/email. Set identity separately if absent:

```sh
git config --global user.name 'Your Name'
git config --global user.email 'you@example.com'
```

## Migrate from the symlink installer

Do this from a **separate checkout** of this version, while the old checkout
still has its original `git/`, `zsh/` and `ghostty/` files. Do not update the old
checkout first: that would make its existing symlinks dangling.

```sh
bash scripts/migrate-legacy.sh /absolute/path/to/old/dotfiles
bash install.sh --dry-run --verbose
bash install.sh
```

The migration only detaches links pointing exactly to the specified old checkout.
It copies their contents into a uniquely named `~/dotfiles-backup.*` directory,
preserves Zsh local overrides, and removes that checkout's old Git includes.
Other existing files remain for chezmoi to compare and prompt about.
If you customized the old tracked Git config (including identity), recover those
settings from the old checkout and set them globally before removing it.
Keep both the backup and old checkout until the new setup is verified.
Migration itself changes live links: run it immediately before installation.

## Daily use

```sh
chezmoi edit ~/.config/zsh/aliases.zsh
chezmoi diff
chezmoi apply
# Commit and push the source changes explicitly.
chezmoi cd
# git add / git commit / git push
```

`chezmoi update` pulls and applies remote changes. There is no network access
from Zsh startup; plugin synchronization happens during apply only.
After using `install.sh` from a custom checkout, use
`chezmoi --source /absolute/path/to/checkout ...` for subsequent commands,
or configure chezmoi's `sourceDir` to that checkout.

`home/` is the chezmoi source state, selected by `.chezmoiroot`; documentation,
package lists, scripts and CI stay outside your home directory. Zsh and Git
modules retain their previous settings. Optional delta integration is refreshed
on every apply according to whether `delta` is available.

## VS Code Dev Containers

Add to your **user** settings.json:

```json
{
  "dotfiles.repository": "adriendellagaspera/dotfiles",
  "dotfiles.installCommand": "bash install.sh"
}
```

New containers run the installer. Internet access and Bash, Git and curl are
required. Install Zsh in the container image and select it as the terminal profile
to use the Zsh configuration. Bash terminals do not load Zsh files.
Use VS Code Settings Sync separately for editor settings and extensions.

## GitHub Codespaces

In https://github.com/settings/codespaces enable **Automatically install dotfiles**
and select this repository. Codespaces discovers `install.sh` automatically.
This applies to newly created codespaces.

## SSH hosts and agent environments

Run the same initial setup on each remote host, or call `bash install.sh` from
the environment's setup hook after cloning the repository. VS Code Remote SSH
uses the configuration on the remote host. Agents need a writable home directory
and must actually launch Zsh to consume Zsh aliases and functions; noninteractive
Bash/sh commands do not inherit them. There is no universal agent setup hook.

## Optional packages

On macOS: `brew bundle --file=packages/Brewfile`.
On Debian/Ubuntu, inspect `packages/apt.txt` before installing the listed packages.
These are explicit operations, separate from chezmoi apply.

## Ghostty and macOS command-line selection

Restart Zsh and reload Ghostty after applying. Interactive clipboard and keyboard
behavior must be checked in a real Ghostty window.

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
