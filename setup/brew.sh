#!/bin/bash

# Install command-line tools using Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

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

# Python and R programming languages for scientific computing
 brew install miniconda

# conda init "$(basename "${SHELL}")"
#  conda create -n jupyter-env jupyter pandas
#  conda activate jupyter-env
 
# Install `wget` with IRI support.
brew install wget 

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Git Hub CLI Tools
brew install git gh

# Network Scan
brew install nmap

# Node
brew install nvm

# install JSON
brew install jq

# Containers
brew install kubectl google-cloud-sdk

# Install Password Management 
brew install 1password

# Install time management
brew install rescuetime

# React Native - Android Development
brew install android-studio google-chrome cocoapods

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
