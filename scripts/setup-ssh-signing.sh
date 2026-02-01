#!/bin/bash
# ------------------------------------------------------------------------------
# setup-ssh-signing.sh - Generate and configure SSH key for commit signing
#
# This creates a DEDICATED signing key, separate from your authentication key.
# See docs/KEYS.md for full explanation of the two-key strategy.
# ------------------------------------------------------------------------------

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
SIGNING_KEY="$HOME/.ssh/id_ed25519_signing"
AUTH_KEY="$HOME/.ssh/id_ed25519"

# Get email from git config, or prompt
EMAIL=$(git config --global user.email 2>/dev/null || true)
if [ -z "$EMAIL" ]; then
    echo -e "${YELLOW}  Git email not configured.${NC}"
    read -p "  Enter your GitHub email: " EMAIL
    git config --global user.email "$EMAIL"
fi

echo ""
echo -e "${BLUE}  ┌─────────────────────────────────────────────────────────────┐${NC}"
echo -e "${BLUE}  │              SSH Key Setup for Git Signing                  │${NC}"
echo -e "${BLUE}  └─────────────────────────────────────────────────────────────┘${NC}"
echo ""
echo "  Email: $EMAIL"
echo ""

# ------------------------------------------------------------------------------
# Step 1: Authentication Key (if missing)
# ------------------------------------------------------------------------------
if [ ! -f "$AUTH_KEY" ]; then
    echo -e "${YELLOW}  Creating authentication key...${NC}"
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$AUTH_KEY" -N ""
    echo -e "${GREEN}  ✓ Created: $AUTH_KEY${NC}"
else
    echo -e "${GREEN}  ✓ Authentication key exists: $AUTH_KEY${NC}"
fi

# ------------------------------------------------------------------------------
# Step 2: Signing Key (if missing)
# ------------------------------------------------------------------------------
if [ ! -f "$SIGNING_KEY" ]; then
    echo ""
    echo -e "${YELLOW}  Creating signing key...${NC}"
    echo "  (This is separate from your auth key for security)"
    echo ""
    ssh-keygen -t ed25519 -C "$EMAIL (signing)" -f "$SIGNING_KEY" -N ""
    echo -e "${GREEN}  ✓ Created: $SIGNING_KEY${NC}"
else
    echo -e "${GREEN}  ✓ Signing key exists: $SIGNING_KEY${NC}"
fi

# ------------------------------------------------------------------------------
# Step 3: Configure Git for SSH signing
# ------------------------------------------------------------------------------
echo ""
echo "  Configuring Git for SSH signing..."

git config --global gpg.format ssh
git config --global user.signingkey "$SIGNING_KEY.pub"
git config --global commit.gpgsign true
git config --global tag.gpgsign true

echo -e "${GREEN}  ✓ Git configured to sign all commits and tags${NC}"

# ------------------------------------------------------------------------------
# Step 4: Add to SSH agent
# ------------------------------------------------------------------------------
echo ""
echo "  Adding keys to SSH agent..."

# Start ssh-agent if not running
eval "$(ssh-agent -s)" > /dev/null 2>&1

# Add keys (macOS Keychain integration)
if [[ "$OSTYPE" == "darwin"* ]]; then
    ssh-add --apple-use-keychain "$AUTH_KEY" 2>/dev/null || ssh-add "$AUTH_KEY"
    ssh-add --apple-use-keychain "$SIGNING_KEY" 2>/dev/null || ssh-add "$SIGNING_KEY"
else
    ssh-add "$AUTH_KEY"
    ssh-add "$SIGNING_KEY"
fi

echo -e "${GREEN}  ✓ Keys added to SSH agent${NC}"

# ------------------------------------------------------------------------------
# Summary and Next Steps
# ------------------------------------------------------------------------------
echo ""
echo -e "${GREEN}  ┌─────────────────────────────────────────────────────────────┐${NC}"
echo -e "${GREEN}  │                     Setup Complete!                         │${NC}"
echo -e "${GREEN}  └─────────────────────────────────────────────────────────────┘${NC}"
echo ""
echo "  Your SSH keys:"
echo ""
echo "  ┌─────────────────┬────────────────────────────────────────────┐"
echo "  │ Authentication  │ ~/.ssh/id_ed25519.pub                      │"
echo "  │ Signing         │ ~/.ssh/id_ed25519_signing.pub              │"
echo "  └─────────────────┴────────────────────────────────────────────┘"
echo ""
echo -e "${YELLOW}  ⚠️  ACTION REQUIRED: Register both keys on GitHub${NC}"
echo ""
echo "  Go to: https://github.com/settings/keys"
echo ""
echo "  ── Key 1: Authentication ──────────────────────────────────────"
echo "  Click 'New SSH key' → Key type: ${GREEN}Authentication Key${NC}"
echo "  Title: MacBook Pro $(date +%Y) - Auth"
echo "  Paste this:"
echo ""
echo -e "${BLUE}$(cat "$AUTH_KEY.pub")${NC}"
echo ""
echo "  ── Key 2: Signing ─────────────────────────────────────────────"
echo "  Click 'New SSH key' → Key type: ${GREEN}Signing Key${NC}"
echo "  Title: MacBook Pro $(date +%Y) - Signing"
echo "  Paste this:"
echo ""
echo -e "${BLUE}$(cat "$SIGNING_KEY.pub")${NC}"
echo ""
echo "  ────────────────────────────────────────────────────────────────"
echo ""
echo "  Verification commands (run after adding keys to GitHub):"
echo "    ssh -T git@github.com          # Test auth"
echo "    git commit --allow-empty -m 'Test signed commit'"
echo "    git log --show-signature -1    # Verify signature"
echo ""
echo "  Full documentation: docs/KEYS.md"
echo ""
