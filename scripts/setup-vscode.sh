#!/bin/bash
# ------------------------------------------------------------------------------
# setup-vscode.sh - Symlink VS Code settings and install extensions
#
# This manages VS Code configuration via dotfiles instead of VS Code's
# built-in Settings Sync. This gives you:
#   - Git-tracked, diffable settings
#   - Explicit control over what's synced
#   - No cloud dependency
#
# IMPORTANT: Disable VS Code Settings Sync after running this script
# ------------------------------------------------------------------------------

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

echo "  Setting up VS Code..."

# Create VS Code user directory if it doesn't exist
mkdir -p "$VSCODE_USER_DIR"

# ------------------------------------------------------------------------------
# Symlink settings
# ------------------------------------------------------------------------------
if [ -f "$DOTFILES_DIR/vscode/settings.json" ]; then
    # Backup existing settings if not already a symlink
    if [ -f "$VSCODE_USER_DIR/settings.json" ] && [ ! -L "$VSCODE_USER_DIR/settings.json" ]; then
        mv "$VSCODE_USER_DIR/settings.json" "$VSCODE_USER_DIR/settings.json.backup"
        echo "  ⊘ Backed up existing settings.json"
    fi
    
    ln -sf "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
    echo "  ✓ Symlinked settings.json"
fi

# ------------------------------------------------------------------------------
# Symlink keybindings
# ------------------------------------------------------------------------------
if [ -f "$DOTFILES_DIR/vscode/keybindings.json" ]; then
    if [ -f "$VSCODE_USER_DIR/keybindings.json" ] && [ ! -L "$VSCODE_USER_DIR/keybindings.json" ]; then
        mv "$VSCODE_USER_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json.backup"
        echo "  ⊘ Backed up existing keybindings.json"
    fi
    
    ln -sf "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
    echo "  ✓ Symlinked keybindings.json"
fi

# ------------------------------------------------------------------------------
# Install extensions
# ------------------------------------------------------------------------------
if [ -f "$DOTFILES_DIR/vscode/extensions.txt" ]; then
    echo "  Installing VS Code extensions..."
    
    # Check if code command is available
    if command -v code &>/dev/null; then
        while IFS= read -r extension || [ -n "$extension" ]; do
            # Skip comments and empty lines
            [[ "$extension" =~ ^#.*$ ]] && continue
            [[ -z "$extension" ]] && continue
            
            echo "    Installing: $extension"
            code --install-extension "$extension" --force 2>/dev/null || true
        done < "$DOTFILES_DIR/vscode/extensions.txt"
        echo "  ✓ Extensions installed"
    else
        echo "  ⚠ 'code' command not found. Install VS Code and run:"
        echo "    Command Palette → 'Shell Command: Install code command in PATH'"
        echo "    Then re-run: ./scripts/setup-vscode.sh"
    fi
fi

echo ""
echo "  ✓ VS Code setup complete"
echo ""
echo "  Remember to disable VS Code Settings Sync:"
echo "    VS Code → Settings → Search 'settings sync' → Turn Off"
