#!/bin/bash
# ------------------------------------------------------------------------------
# bootstrap.sh - Symlink dotfiles to home directory
#
# This script creates symlinks from ~ to the dotfiles in this repo.
# Using symlinks (instead of copying) means:
#   - Changes to dotfiles are immediately reflected
#   - You can easily see what's managed: ls -la ~ | grep '\->'
#   - Git diff shows exactly what changed
#
# Run: ./bootstrap.sh
# ------------------------------------------------------------------------------

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Files to symlink (source -> target)
# Add or remove files as needed
declare -a DOTFILES=(
    ".aliases"
    ".curlrc"
    ".editorconfig"
    ".exports"
    ".functions"
    ".gitattributes"
    ".gitconfig"
    ".gitignore"
    ".hushlogin"
    ".inputrc"
    ".screenrc"
    ".tmux.conf"
    ".vimrc"
    ".gvimrc"
    ".wgetrc"
    ".zshrc"
)

# Function to create a symlink with backup
create_symlink() {
    local src="$1"
    local dest="$2"
    
    # If destination exists and is not a symlink, back it up
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        mv "$dest" "${dest}.backup.$(date +%Y%m%d%H%M%S)"
        echo -e "  ${YELLOW}⊘${NC} Backed up: $dest"
    fi
    
    # Remove existing symlink if it exists
    [ -L "$dest" ] && rm "$dest"
    
    # Create symlink
    ln -sf "$src" "$dest"
    echo -e "  ${GREEN}✓${NC} Linked: $(basename $dest)"
}

echo ""
echo "  Symlinking dotfiles to home directory..."
echo ""

# Symlink each dotfile
for file in "${DOTFILES[@]}"; do
    if [ -f "$DOTFILES_DIR/$file" ]; then
        create_symlink "$DOTFILES_DIR/$file" "$HOME/$file"
    else
        echo -e "  ${YELLOW}⚠${NC} Not found: $file (skipping)"
    fi
done

# Handle special directories (init, bin, etc.) if they exist
if [ -d "$DOTFILES_DIR/bin" ]; then
    echo ""
    echo "  Symlinking bin directory..."
    mkdir -p "$HOME/bin"
    for script in "$DOTFILES_DIR/bin/"*; do
        if [ -f "$script" ]; then
            create_symlink "$script" "$HOME/bin/$(basename $script)"
        fi
    done
fi

echo ""
echo -e "  ${GREEN}✓${NC} Dotfiles symlinked"
echo ""
echo "  To see all symlinked files:"
echo "    ls -la ~ | grep '\\->'"
echo ""

# Source .zshrc if running in zsh
if [ -n "$ZSH_VERSION" ]; then
    echo "  Reloading shell configuration..."
    source "$HOME/.zshrc"
fi
