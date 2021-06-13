#!/bin/zsh

# to maintain cask ....
brew update && brew upgrade && brew cleanup

# Local VM Management
brew install --cask virtualbox vagrant

# Install native apps
brew tap homebrew/cask-versions

# Daily
brew install --cask spectacle dropbox evernote brave-browser paw obsidian

# VPN
brew install --cask private-internet-access

# Dev Tools
brew install --cask iterm2 visual-studio-code

# Communication
brew install --cask slack

# Remove outdated versions from the cellar
brew cleanup

# Repo Info
brew list && brew info
