#!/bin/bash

# to maintain cask ....
brew update && brew upgrade && brew cleanup

# VM Management
brew cask install virtualbox vagrant

# Install native apps
brew tap caskroom/versions

# daily
brew cask install spectacle dropbox 1password flux evernote macdown brave-browser

# developer tools 
brew cask install iterm2 visual-studio-code slack

