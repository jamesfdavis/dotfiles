#!/bin/bash
# ------------------------------------------------------------------------------
# install.sh - Main dotfiles installation orchestrator
# 
# Usage: ./install.sh
# 
# This script runs all setup scripts in order:
# 1. Homebrew + packages (Brewfile)
# 2. Oh My Zsh + plugins
# 3. Symlink dotfiles
# 4. SSH signing key setup
# 5. VS Code configuration
# 6. macOS defaults (optional)
# ------------------------------------------------------------------------------

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script lives
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║           🚀 Dotfiles Installation - 2026 Refresh            ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Dotfiles location: ${GREEN}$DOTFILES_DIR${NC}"
echo ""

# ------------------------------------------------------------------------------
# Pre-flight checks
# ------------------------------------------------------------------------------
echo -e "${YELLOW}▶ Running pre-flight checks...${NC}"

# Check for Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
    echo -e "${YELLOW}  Installing Xcode Command Line Tools...${NC}"
    xcode-select --install
    echo -e "${YELLOW}  Please wait for installation to complete, then re-run this script.${NC}"
    exit 1
fi
echo -e "${GREEN}  ✓ Xcode Command Line Tools installed${NC}"

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}  ✗ This script is designed for macOS${NC}"
    exit 1
fi
echo -e "${GREEN}  ✓ Running on macOS${NC}"

echo ""

# ------------------------------------------------------------------------------
# Step 1: Homebrew
# ------------------------------------------------------------------------------
echo -e "${YELLOW}▶ Step 1/6: Setting up Homebrew...${NC}"
"$DOTFILES_DIR/scripts/setup-homebrew.sh"
echo ""

# ------------------------------------------------------------------------------
# Step 2: Oh My Zsh
# ------------------------------------------------------------------------------
echo -e "${YELLOW}▶ Step 2/6: Setting up Oh My Zsh...${NC}"
"$DOTFILES_DIR/scripts/setup-oh-my-zsh.sh"
echo ""

# ------------------------------------------------------------------------------
# Step 3: Symlink dotfiles
# ------------------------------------------------------------------------------
echo -e "${YELLOW}▶ Step 3/6: Symlinking dotfiles...${NC}"
"$DOTFILES_DIR/bootstrap.sh"
echo ""

# ------------------------------------------------------------------------------
# Step 4: SSH Signing Key
# ------------------------------------------------------------------------------
echo -e "${YELLOW}▶ Step 4/6: Setting up SSH commit signing...${NC}"
"$DOTFILES_DIR/scripts/setup-ssh-signing.sh"
echo ""

# ------------------------------------------------------------------------------
# Step 5: VS Code
# ------------------------------------------------------------------------------
echo -e "${YELLOW}▶ Step 5/6: Setting up VS Code...${NC}"
"$DOTFILES_DIR/scripts/setup-vscode.sh"
echo ""

# ------------------------------------------------------------------------------
# Step 6: macOS Defaults (optional)
# ------------------------------------------------------------------------------
echo -e "${YELLOW}▶ Step 6/6: macOS Defaults${NC}"
echo ""
read -p "  Apply sensible macOS defaults? (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    "$DOTFILES_DIR/.macos"
    echo -e "${GREEN}  ✓ macOS defaults applied${NC}"
else
    echo -e "${BLUE}  ⊘ Skipped macOS defaults${NC}"
fi

echo ""

# ------------------------------------------------------------------------------
# Complete
# ------------------------------------------------------------------------------
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    ✅ Installation Complete!                  ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo ""
echo "  1. Restart your terminal (or run: source ~/.zshrc)"
echo ""
echo "  2. Install Node.js LTS:"
echo "     nvm install --lts"
echo ""
echo "  3. Register SSH keys on GitHub:"
echo "     - Auth key:    ~/.ssh/id_ed25519.pub → 'Authentication Key'"
echo "     - Signing key: ~/.ssh/id_ed25519_signing.pub → 'Signing Key'"
echo "     See: docs/KEYS.md for detailed instructions"
echo ""
echo "  4. Set up ~/.extra with your personal credentials:"
echo "     cp ~/.extra.example ~/.extra"
echo "     # Edit with your details"
echo ""
echo "  5. Disable VS Code Settings Sync (we manage via dotfiles now):"
echo "     VS Code → Settings → Search 'sync' → Turn off Settings Sync"
echo ""
echo -e "${BLUE}Happy coding! 🎉${NC}"
echo ""
