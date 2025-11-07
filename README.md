# Dotfiles

Portable Git-first dotfiles so your workflow feels the same on any machine (local, CI runners, or disposable containers).

## Features

- Modular Git config (`git/.gitconfig`) with sane defaults (pruned fetches, `main` default branch, `zdiff3` conflicts, rerere, histogram diffs, commit template, short status).
- Rich alias pack grouped by task (branch hygiene, log views, workflow helpers, inspection tools) in `git/.gitconfig-aliases`.
- Opinionated global ignore file plus a commit message template that are symlinked into `$HOME` so edits follow the repo.
- Optional include that lights up [delta](https://github.com/dandavison/delta) as the pager whenever it is available (and automatically removed when it is not).
- Idempotent installer that works from any checkout path, backs up existing dotfiles, and keeps your global Git config tidy.
- First-class zsh setup with XDG-friendly layout (`~/.zshenv` + `~/.config/zsh`), ergonomic defaults (history, completion, prompt, aliases), and optional plugins (autosuggestions, syntax highlighting, completions, fzf) that auto-sync into `~/.local/share/zsh/plugins`.
- Automatically adopts modern CLI helpers when they are installed: `eza` powers richer directory and tree views, while `zoxide` gives jump-to-anywhere directory navigation (with a handy `j` alias).

## Installation

```bash
./install.sh
```

The script:

1. Detects the repository path automatically, so you can run it from any clone (even inside containers).
2. Adds the Git include(s) only once and keeps them up to date.
3. Symlinks `git/.gitignore_global` → `~/.gitignore_global` and `git/.gitmessage` → `~/.gitmessage`, backing up any existing files as `*.backup.<timestamp>`.
4. Links `zsh/.zshenv` → `~/.zshenv` and `zsh/config` → `~/.config/zsh`, keeping everything XDG-aligned.
5. Enables the delta config when `delta` is installed, and removes it when it is missing so `git diff` never breaks.
6. Optionally clones/updates the zsh plugins defined in `zsh/config/plugins.list` whenever `zsh` is present (set `DOTFILES_SKIP_ZSH_PLUGINS=1` to opt out—handy on restricted networks).

Re-run the installer any time—you can keep tweaking the repo and immediately sync the changes onto the host/container.

## Customize

1. Edit `git/.gitconfig` and set your `user.name` / `user.email` (the defaults are placeholders).
2. Adjust the global ignore or commit template to match team conventions; because the files are symlinked into `$HOME`, all editors use the repo version.
3. Install [`delta`](https://github.com/dandavison/delta) if you want side-by-side diffs; otherwise the standard pager is left untouched.
4. Install [`eza`](https://github.com/eza-community/eza) for a faster, git-aware `ls`, and [`zoxide`](https://github.com/ajeetdsouza/zoxide) for AI-like `cd`—the shell config detects them automatically.
5. Customize the zsh stack by editing files under `zsh/config/` (e.g., extend `aliases.zsh`, tweak `prompt.zsh`, or change the plugin list). You can also drop `.zsh` snippets into `~/.config/zsh/local/` for machine-specific overrides that stay out of git.

## Zsh highlights

- `.zshenv` keeps `$ZDOTDIR` and `$DOTFILES_ROOT` consistent everywhere (interactive shells, scripts, login shells).
- `~/.config/zsh/.zshrc` sources modular files for path/env setup, shell options, completions, aliases, prompt, and plugins.
- History lives under `${XDG_STATE_HOME:-~/.local/state}/zsh/history`, giving you 200k entries with `history-beginning-search` keybindings.
- Prompt built on `vcs_info` shows branch, staged/unstaged markers, exit status, and a right-aligned clock.
- Plugin manager keeps repositories under `${XDG_DATA_HOME:-~/.local/share}/zsh/plugins`; edit `zsh/config/plugins.list` to add/remove entries, then rerun `./install.sh` to sync.
- If you are offline or behind a restrictive network policy, export `DOTFILES_SKIP_ZSH_PLUGINS=1` before running the installer to quiet plugin-clone warnings. Re-run without the flag once you regain access.
- When `eza` is available the standard `ls`, `ll`, `la`, and `tree` aliases upgrade automatically (grouping directories first, showing git info, icons, etc.). When it is not, the regular `ls` aliases remain in place.
- When `zoxide` is installed, it transparently extends `cd`/`z` history and exposes a `j <pattern>` shortcut for fuzzy directory jumps.

## More CLI helpers (use cases)

- **`fd`**: instant recursive file search with sensible defaults (respects `.gitignore`, color output). Perfect for narrowing down candidates before handing them to `fzf` or `rg`.
- **`ripgrep` (`rg`)**: the fastest way to search huge codebases; integrates with editors (VS Code, Helix, Neovim Telescope) and honors ignore files by default.
- **`bat`**: a drop-in `cat` replacement with syntax highlighting, git blame sidebar, and paging—fantastic for reviewing configs straight from the CLI.
- **`direnv`**: keeps per-project environment variables (language toolchains, credentials, feature flags) in sync automatically as you `cd` around.
- **`starship`**: asynchronous, git-aware prompt written in Rust; keeps shells snappy even in large repos and works across Bash, Zsh, Fish, etc.
- **`fzf`**: terminal fuzzy finder you can combine with `git`, `rg`, or `fd` pipes for interactive selections (e.g., `git ls-files | fzf | xargs $EDITOR`).
- **`dust`**: a modern `du` that visualizes disk usage in sorted, colored output—great for pruning large node_modules or build artifacts.
- fzf integration auto-loads when `fzf` is installed (via the stock `~/.fzf.zsh` script), and autosuggestions gain a `<Ctrl-Space>` accept binding.

## Git aliases snapshot

| Alias | Description |
| --- | --- |
| `list-gone`, `prune-gone`, `prune-merged`, `recent` | Clean up dead branches and sort by activity. |
| `lg`, `lga`, `ll`, `last`, `files` | Beautiful history browsers with relative dates and file summaries. |
| `undo`, `uncommit`, `unstage`, `staged`, `amend`, `fixup`, `continue`, `wip`, `please` | Workflow accelerators for everyday Git chores. |
| `coauthors`, `root`, `blame`, `tags`, `shortstat` | Inspection helpers for reviewing and composing commits. |

Run `git config --global --get-regexp alias` to inspect the full list after installing.

## Repository Structure

```
dotfiles/
├── git/
│   ├── .gitconfig            # Core Git defaults (includes aliases)
│   ├── .gitconfig-aliases    # Alias definitions grouped by workflow
│   ├── .gitconfig.delta      # Optional delta-specific tuning
│   ├── .gitignore_global     # Global ignore patterns
│   └── .gitmessage           # Conventional commits template
├── zsh/
│   ├── .zshenv               # Sets DOTFILES + XDG-aware ZDOTDIR
│   └── config/               # Modular zsh config (rc, aliases, prompt, plugins)
├── install.sh                # Idempotent installer / bootstrapper
└── README.md                 # This file
```

Feel free to fork and tailor further—these files are intentionally small and easy to extend. Running `./install.sh` again will propagate any new additions.
