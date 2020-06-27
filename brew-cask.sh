#!/bin/bash

# to maintain cask ....
brew update && brew upgrade && brew cleanup

# VM Management
brew cask install virtualbox vagrant

# Install native apps
brew tap homebrew/cask-versions

# daily
brew cask install spectacle dropbox evernote macdown brave-browser

# vpn 
brew cask install private-internet-access

# developer tools 
brew cask install iterm2 visual-studio-code slack

