# Dotfiles

Personal configuration files for development environment.

## Installation

### Quick Install (All configs)

```bash
./install.sh
```

### Manual Install

#### Git Configuration

To use the Git aliases, add this to your `~/.gitconfig`:

```ini
[include]
    path = ~/dotfiles/git/.gitconfig-aliases
```

Or run:

```bash
git config --global include.path ~/dotfiles/git/.gitconfig-aliases
```

## Git Aliases

### Branch Management

- `git list-gone` - List local branches whose remote has been deleted
- `git prune-gone` - Delete all local branches whose remote has been deleted

### Workflow Shortcuts

- `git lg` - Pretty, colorful commit log graph
- `git recent` - Show branches sorted by last modified date
- `git undo` - Undo last commit but keep changes staged
- `git last` - Show what was changed in the last commit
- `git amend` - Amend last commit without changing the message

## Usage Examples

### Clean up merged branches

```bash
# After merging PRs on GitHub
git fetch --all --prune    # Update remote tracking info
git list-gone              # Preview which branches will be deleted
git prune-gone            # Delete them
```

### View commit history

```bash
git lg                     # Beautiful graph view
git lg -10                # Last 10 commits
```

### Quick fixes

```bash
git commit -m "Fix bug"
# Oops, forgot a file!
git add forgotten-file.txt
git amend                 # Adds to last commit without changing message
```

## Repository Structure

```
dotfiles/
├── git/
│   └── .gitconfig-aliases    # Git aliases and shortcuts
├── install.sh                # Installation script
└── README.md                 # This file
```

## Contributing

These are personal configurations, but feel free to fork and adapt to your needs!

