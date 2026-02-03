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

# Clean up stale downloads to avoid checksum mismatches
echo "  Cleaning up stale downloads..."
brew cleanup -s 2>/dev/null || true

# Install packages from Brewfile with retry logic
echo "  Installing packages from Brewfile..."
MAX_RETRIES=3
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if brew bundle --file="$DOTFILES_DIR/Brewfile"; then
        echo "  ✓ Homebrew setup complete"
        exit 0
    fi

    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
        echo "  ⚠ brew bundle failed, retrying ($RETRY_COUNT/$MAX_RETRIES)..."
        echo "  Cleaning cache and updating formulas..."
        brew cleanup -s 2>/dev/null || true
        brew update
        sleep 2
    fi
done

echo "  ✗ brew bundle failed after $MAX_RETRIES attempts"
echo "  Tip: Try running 'brew update && brew cleanup' then retry"
exit 1
