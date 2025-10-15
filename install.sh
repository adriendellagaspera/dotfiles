#!/bin/bash

# Dotfiles installation script
# This script sets up Git configuration

set -e

DOTFILES_DIR="$HOME/dotfiles"

echo "🚀 Installing dotfiles..."

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "❌ Error: Dotfiles directory not found at $DOTFILES_DIR"
    exit 1
fi

# Git configuration
echo "📦 Setting up Git aliases..."
if git config --global include.path ~/dotfiles/git/.gitconfig-aliases; then
    echo "✅ Git aliases configured"
else
    echo "❌ Failed to configure Git aliases"
    exit 1
fi

echo ""
echo "✨ Installation complete!"
echo ""
echo "Available Git aliases:"
echo "  - git list-gone    : List branches with deleted remotes"
echo "  - git prune-gone   : Delete branches with deleted remotes"
echo "  - git lg           : Pretty commit log"
echo "  - git recent       : Recent branches"
echo "  - git undo         : Undo last commit (keep changes)"
echo "  - git last         : Show last commit"
echo "  - git amend        : Amend last commit"
echo ""
echo "Run 'git <alias>' to use them!"

