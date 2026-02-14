#!/bin/bash
# install.sh - Dotfiles installer for agent-first Cloudflare development
#
# Usage: ./install.sh
#
# Steps:
# 1. Homebrew + packages (Brewfile)
# 2. Symlink dotfiles + config files
# 3. macOS defaults (keyboard, trackpad, Finder, Dock)
# 4. SSH signing key setup + Keychain persistence
# 5. Node.js LTS via NVM
# 6. npm globals (claude-code, wrangler)

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
echo -e "${YELLOW}  Step 1/6: Homebrew...${NC}"
"$DOTFILES_DIR/scripts/setup-homebrew.sh"
echo ""

# Step 2: Symlink dotfiles + config
echo -e "${YELLOW}  Step 2/6: Symlinking dotfiles...${NC}"
"$DOTFILES_DIR/bootstrap.sh"
echo ""

# Step 3: macOS defaults
echo -e "${YELLOW}  Step 3/6: Applying macOS defaults...${NC}"
"$DOTFILES_DIR/scripts/setup-macos.sh"
echo ""

# Step 4: SSH Signing Key
echo -e "${YELLOW}  Step 4/6: SSH commit signing + Keychain persistence...${NC}"
"$DOTFILES_DIR/scripts/setup-ssh-signing.sh"
echo ""

# Step 5: Node.js + npm globals
echo -e "${YELLOW}  Step 5/6: Installing Node.js LTS via NVM...${NC}"

# Determine HOMEBREW_PREFIX for NVM
if [[ $(uname -m) == "arm64" ]]; then
    _HP="/opt/homebrew"
else
    _HP="/usr/local"
fi

export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
if [ -s "$_HP/opt/nvm/nvm.sh" ]; then
    \. "$_HP/opt/nvm/nvm.sh"
    nvm install --lts 2>/dev/null && \
        echo -e "${GREEN}  Node.js LTS installed$(node -v 2>/dev/null && echo " ($(node -v))")${NC}" || \
        echo -e "${YELLOW}  NVM install failed (can retry: nvm install --lts)${NC}"
else
    echo -e "${YELLOW}  NVM not found -- run 'nvm install --lts' after restart${NC}"
fi

# Step 6: npm globals
echo -e "${YELLOW}  Step 6/6: Installing npm globals...${NC}"
if command -v npm &>/dev/null; then
    npm install -g @anthropic-ai/claude-code 2>/dev/null && \
        echo -e "${GREEN}  Installed claude-code${NC}" || \
        echo -e "${YELLOW}  claude-code install failed (can retry later)${NC}"

    npm install -g wrangler 2>/dev/null && \
        echo -e "${GREEN}  Installed wrangler${NC}" || \
        echo -e "${YELLOW}  wrangler install failed (can retry later)${NC}"
else
    echo -e "${RED}  npm not found - restart terminal and run: nvm install --lts${NC}"
fi
echo ""

# Post-install verification
echo -e "${YELLOW}  Verifying installation...${NC}"
_fail=0

command -v claude &>/dev/null && \
    echo -e "${GREEN}  claude-code $(claude --version 2>/dev/null)${NC}" || \
    { echo -e "${RED}  claude-code not found${NC}"; _fail=1; }

command -v wrangler &>/dev/null && \
    echo -e "${GREEN}  wrangler $(wrangler --version 2>/dev/null)${NC}" || \
    { echo -e "${RED}  wrangler not found${NC}"; _fail=1; }

command -v node &>/dev/null && \
    echo -e "${GREEN}  node $(node --version 2>/dev/null)${NC}" || \
    { echo -e "${RED}  node not found${NC}"; _fail=1; }

command -v gh &>/dev/null && \
    echo -e "${GREEN}  gh $(gh --version 2>/dev/null | head -1)${NC}" || \
    { echo -e "${RED}  gh not found${NC}"; _fail=1; }

if [ "$_fail" -eq 1 ]; then
    echo ""
    echo -e "${YELLOW}  Some tools missing. Restart your terminal and re-run failed steps.${NC}"
fi
echo ""

# Done
echo -e "${GREEN}  Installation complete.${NC}"
echo ""
echo -e "${YELLOW}  Next steps:${NC}"
echo ""
echo "  1. Restart your terminal (or: source ~/.zshrc)"
echo ""
echo "  2. If Node install was skipped: nvm install --lts"
echo ""
echo "  3. Register SSH keys on GitHub (https://github.com/settings/keys):"
echo "     Auth key:    cat ~/.ssh/id_ed25519.pub"
echo "     Signing key: cat ~/.ssh/id_ed25519_signing.pub"
echo ""
echo "  4. Set up secrets:"
echo "     cp ~/.extra.example ~/.extra && nvim ~/.extra"
echo ""
echo "  5. Start Colima for Docker:"
echo "     colima start"
echo ""
echo "  6. Authenticate GitHub CLI:"
echo "     gh auth login"
echo ""
