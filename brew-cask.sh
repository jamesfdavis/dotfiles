#!/bin/bash

# to maintain cask ....
brew update && brew upgrade && brew cleanup

# VM Management
brew cask install virtualbox vagrant

# Install native apps
brew tap homebrew/cask-versions

# daily
brew cask install spectacle dropbox flux evernote macdown brave-browser

# developer tools 
brew cask install iterm2 visual-studio-code slack

