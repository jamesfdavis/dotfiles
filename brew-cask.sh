#!/bin/bash

# to maintain cask ....
brew update && brew upgrade && brew cleanup

# VM Management
brew install --cask virtualbox vagrant

# Install native apps
brew tap homebrew/cask-versions

# daily
brew install --cask spectacle dropbox evernote macdown brave-browser

# vpn 
brew install --cask private-internet-access

# developer tools 
brew install --cask iterm2 visual-studio-code slack ngrok
