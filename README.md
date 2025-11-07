# Dotfiles

Portable Git-first dotfiles so your workflow feels the same on any machine (local, CI runners, or disposable containers).

## Features

- Modular Git config (`git/.gitconfig`) with sane defaults (pruned fetches, `main` default branch, `zdiff3` conflicts, rerere, histogram diffs, commit template, short status).
- Rich alias pack grouped by task (branch hygiene, log views, workflow helpers, inspection tools) in `git/.gitconfig-aliases`.
- Opinionated global ignore file plus a commit message template that are symlinked into `$HOME` so edits follow the repo.
- Optional include that lights up [delta](https://github.com/dandavison/delta) as the pager whenever it is available (and automatically removed when it is not).
- Idempotent installer that works from any checkout path, backs up existing dotfiles, and keeps your global Git config tidy.

## Installation

```bash
./install.sh
```

The script:

1. Detects the repository path automatically, so you can run it from any clone (even inside containers).
2. Adds the Git include(s) only once and keeps them up to date.
3. Symlinks `git/.gitignore_global` → `~/.gitignore_global` and `git/.gitmessage` → `~/.gitmessage`, backing up any existing files as `*.backup.<timestamp>`.
4. Enables the delta config when `delta` is installed, and removes it when it is missing so `git diff` never breaks.

Re-run the installer any time—you can keep tweaking the repo and immediately sync the changes onto the host/container.

## Customize

1. Edit `git/.gitconfig` and set your `user.name` / `user.email` (the defaults are placeholders).
2. Adjust the global ignore or commit template to match team conventions; because the files are symlinked into `$HOME`, all editors use the repo version.
3. Install [`delta`](https://github.com/dandavison/delta) if you want side-by-side diffs; otherwise the standard pager is left untouched.

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
├── install.sh                # Idempotent installer / bootstrapper
└── README.md                 # This file
```

Feel free to fork and tailor further—these files are intentionally small and easy to extend. Running `./install.sh` again will propagate any new additions.
