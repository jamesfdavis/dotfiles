#!/bin/bash
# ------------------------------------------------------------------------------
# setup-oh-my-zsh.sh - Install Oh My Zsh and configure plugins
# ------------------------------------------------------------------------------

set -e

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "  Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "  ✓ Oh My Zsh installed"
else
    echo "  ✓ Oh My Zsh already installed"
fi

# zsh-autosuggestions plugin (installed via Homebrew, just needs linking)
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Link Homebrew plugins to Oh My Zsh custom plugins directory
# Note: The actual plugins are installed via Brewfile, we configure them in .zshrc

echo "  ✓ Oh My Zsh plugins configured"
echo ""
echo "  Plugins enabled:"
echo "    - git (built-in)"
echo "    - zsh-autosuggestions (Homebrew)"
echo "    - zsh-syntax-highlighting (Homebrew)"
echo ""
echo "  Note: Plugin loading is configured in .zshrc"
