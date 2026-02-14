#!/bin/bash
# setup-macos.sh - Set macOS defaults for a dev-optimized environment
#
# Usage: ./scripts/setup-macos.sh
#
# Note: Some changes require a logout or restart to take effect.

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "  Applying macOS defaults..."
echo ""

# Close System Preferences to prevent overriding changes
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

###############################################################################
# Keyboard & Cursor                                                           #
###############################################################################

# Fast key repeat rate (lower = faster, default: 6)
defaults write NSGlobalDomain KeyRepeat -int 2
echo -e "  ${GREEN}KeyRepeat = 2${NC}"

# Short delay before key repeat starts (lower = shorter, default: 25)
defaults write NSGlobalDomain InitialKeyRepeat -int 15
echo -e "  ${GREEN}InitialKeyRepeat = 15${NC}"

# Enable full keyboard access for all controls (Tab through all UI elements)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
echo -e "  ${GREEN}Full keyboard access enabled${NC}"

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
echo -e "  ${GREEN}Press-and-hold disabled (key repeat enabled everywhere)${NC}"

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
echo -e "  ${GREEN}Auto-correct disabled${NC}"

###############################################################################
# Trackpad & Mouse                                                            #
###############################################################################

# Trackpad speed (default: ~1.0, range 0-3)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.0
echo -e "  ${GREEN}Trackpad scaling = 1.0${NC}"

# Enable tap to click for trackpad
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
echo -e "  ${GREEN}Tap to click enabled${NC}"

###############################################################################
# Sound                                                                       #
###############################################################################

# Mute startup chime (requires sudo)
if sudo -n true 2>/dev/null; then
    sudo nvram StartupMute=%01
    echo -e "  ${GREEN}Startup sound muted${NC}"
else
    echo -e "  ${YELLOW}Startup sound: run 'sudo nvram StartupMute=%01' (needs sudo)${NC}"
fi

###############################################################################
# Finder                                                                      #
###############################################################################

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true
echo -e "  ${GREEN}Finder: show hidden files${NC}"

# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
echo -e "  ${GREEN}Finder: show all file extensions${NC}"

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true
echo -e "  ${GREEN}Finder: show path bar${NC}"

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
echo -e "  ${GREEN}Finder: no extension change warning${NC}"

###############################################################################
# Dock                                                                        #
###############################################################################

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true
echo -e "  ${GREEN}Dock: auto-hide enabled${NC}"

# Remove auto-hide delay
defaults write com.apple.dock autohide-delay -float 0
echo -e "  ${GREEN}Dock: no auto-hide delay${NC}"

# Speed up auto-hide animation
defaults write com.apple.dock autohide-time-modifier -float 0.3
echo -e "  ${GREEN}Dock: fast auto-hide animation${NC}"

###############################################################################
# Apply changes                                                               #
###############################################################################

echo ""
echo -e "  ${YELLOW}Restarting affected apps...${NC}"
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true

echo ""
echo -e "  ${GREEN}macOS defaults applied.${NC}"
echo -e "  ${YELLOW}Some changes (keyboard repeat, startup sound) require logout/restart.${NC}"
echo ""
