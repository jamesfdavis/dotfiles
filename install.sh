#!/bin/bash
# install.sh - Dotfiles installer for agent-first Cloudflare development
#
# Usage: ./install.sh
#
# Steps:
# 1. Homebrew + packages (Brewfile)
# 2. Symlink dotfiles + config files
# 3. SSH signing key setup
# 4. npm globals (claude-code, wrangler)

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo -e "${BLUE}  Dotfiles - Agent-first Cloudflare Development${NC}"
echo -e "  Location: ${GREEN}$DOTFILES_DIR${NC}"
echo ""

# Pre-flight
echo -e "${YELLOW}  Pre-flight checks...${NC}"

if ! xcode-select -p &>/dev/null; then
    echo -e "${YELLOW}  Installing Xcode Command Line Tools...${NC}"
    xcode-select --install
    echo -e "${YELLOW}  Wait for install to complete, then re-run this script.${NC}"
    exit 1
fi
echo -e "${GREEN}  Xcode CLT installed${NC}"

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}  This script is designed for macOS${NC}"
    exit 1
fi
echo -e "${GREEN}  Running on macOS${NC}"
echo ""

# Step 1: Homebrew
echo -e "${YELLOW}  Step 1/4: Homebrew...${NC}"
"$DOTFILES_DIR/scripts/setup-homebrew.sh"
echo ""

# Step 2: Symlink dotfiles + config
echo -e "${YELLOW}  Step 2/4: Symlinking dotfiles...${NC}"
"$DOTFILES_DIR/bootstrap.sh"
echo ""

# Step 3: SSH Signing Key
echo -e "${YELLOW}  Step 3/4: SSH commit signing...${NC}"
"$DOTFILES_DIR/scripts/setup-ssh-signing.sh"
echo ""

# Step 4: npm globals
echo -e "${YELLOW}  Step 4/4: Installing npm globals...${NC}"
if command -v npm &>/dev/null; then
    npm install -g @anthropic-ai/claude-code 2>/dev/null && \
        echo -e "${GREEN}  Installed claude-code${NC}" || \
        echo -e "${YELLOW}  claude-code install failed (can retry later)${NC}"

    npm install -g wrangler 2>/dev/null && \
        echo -e "${GREEN}  Installed wrangler${NC}" || \
        echo -e "${YELLOW}  wrangler install failed (can retry later)${NC}"
else
    echo -e "${RED}  npm not found - install Node first${NC}"
fi
echo ""

# Done
echo -e "${GREEN}  Installation complete.${NC}"
echo ""
echo -e "${YELLOW}  Next steps:${NC}"
echo ""
echo "  1. Restart your terminal (or: source ~/.zshrc)"
echo ""
echo "  2. Register SSH keys on GitHub (https://github.com/settings/keys):"
echo "     Auth key:    cat ~/.ssh/id_ed25519.pub"
echo "     Signing key: cat ~/.ssh/id_ed25519_signing.pub"
echo ""
echo "  3. Set up secrets:"
echo "     cp ~/.extra.example ~/.extra && nvim ~/.extra"
echo ""
echo "  4. Start Colima for Docker:"
echo "     colima start"
echo ""
echo "  5. Authenticate GitHub CLI:"
echo "     gh auth login"
echo ""
