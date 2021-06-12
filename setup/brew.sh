#!/bin/bash

# Install command-line tools using Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Make sure we’re using the latest Homebrew
brew update && brew upgrade

# GNU core utilities (those that come with OS X are outdated)help
brew install coreutils moreutils htop

# Diagrams # https://diagrams.mingrammer.com
brew install graphviz

# GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils ack

# GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed 

# generic colouriser  http://kassiopeia.juls.savba.sk/~garabik/software/grc/
brew install grc

# Directory Tree
brew install tree

# Install `wget` with IRI support.
brew install wget 

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Git Hub CLI Tools
brew install git gh

# Network Scan
brew install nmap 

# install JSON
brew install jq

# Install Password Management 
brew install 1password

# Install time management
brew install rescuetime

# Install more recent versions of some OS X tools
brew install vim grep openssh screen

# install public key in a remote machine's authorized_keys
brew install ssh-copy-id

# mtr - ping & traceroute. best.
brew install mtr
brew install pidcat # colored logcat guy

# ZSH Extensions
brew install zsh-syntax-highlighting
brew install zsh-autosuggestions

# Remove outdated versions from the cellar
brew cleanup

# Repo Info
brew list && brew info
