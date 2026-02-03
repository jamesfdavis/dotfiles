#!/bin/bash
# ------------------------------------------------------------------------------
# setup-homebrew.sh - Install Homebrew and packages from Brewfile
# ------------------------------------------------------------------------------
set -e
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
    echo "  Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    echo "  ✓ Homebrew installed"
else
    echo "  ✓ Homebrew already installed"
fi
# Update Homebrew
echo "  Updating Homebrew..."
brew update
# Install packages from Brewfile
echo "  Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"
echo "  ✓ Homebrew setup complete"
