#!/bin/bash
# bootstrap.sh - Symlink dotfiles and config files to their expected locations

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

create_symlink() {
    local src="$1"
    local dest="$2"

    # Backup existing non-symlink files
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        mv "$dest" "${dest}.backup.$(date +%Y%m%d%H%M%S)"
        echo -e "  ${YELLOW}Backed up: $dest${NC}"
    fi

    [ -L "$dest" ] && rm "$dest"

    ln -sf "$src" "$dest"
    echo -e "  ${GREEN}Linked: $(basename $dest)${NC}"
}

echo ""
echo "  Symlinking dotfiles..."
echo ""

# Home directory dotfiles
declare -a DOTFILES=(
    ".aliases"
    ".editorconfig"
    ".exports"
    ".functions"
    ".gitattributes"
    ".gitconfig"
    ".gitignore"
    ".hushlogin"
    ".inputrc"
    ".zshrc"
)

for file in "${DOTFILES[@]}"; do
    if [ -f "$DOTFILES_DIR/$file" ]; then
        create_symlink "$DOTFILES_DIR/$file" "$HOME/$file"
    else
        echo -e "  ${YELLOW}Not found: $file (skipping)${NC}"
    fi
done

# ~/.config symlinks
echo ""
echo "  Symlinking config directories..."
echo ""

mkdir -p "$HOME/.config"

# Ghostty
if [ -d "$DOTFILES_DIR/config/ghostty" ]; then
    create_symlink "$DOTFILES_DIR/config/ghostty" "$HOME/.config/ghostty"
fi

# Starship
if [ -f "$DOTFILES_DIR/config/starship.toml" ]; then
    create_symlink "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"
fi

# Neovim
if [ -d "$DOTFILES_DIR/config/nvim" ]; then
    create_symlink "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
fi

# Ripgrep config
if [ -f "$DOTFILES_DIR/.ripgreprc" ]; then
    create_symlink "$DOTFILES_DIR/.ripgreprc" "$HOME/.ripgreprc"
fi

echo ""
echo -e "  ${GREEN}Dotfiles symlinked.${NC}"
echo ""
