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
