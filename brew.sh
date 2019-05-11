#!/bin/bash

# Install command-line tools using Homebrew

# Dependency
brew cask install java

# GoLang
brew install go

# Make sure we’re using the latest Homebrew
brew update && brew upgrade

# GNU core utilities (those that come with OS X are outdated)help
brew install coreutils moreutils htop

# GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils

# GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed 

# Bash 5
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before running `chsh`.
brew install bash
# brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;

# generic colouriser  http://kassiopeia.juls.savba.sk/~garabik/software/grc/
brew install grc

# Orchestration
brew install docker-compose docker-machine kubernetes-cli

# Install `wget` with IRI support.
brew install wget 

# Install GnuPG/Yubikey to enable PGP-signing commits.
brew install gnupg yubikey-personalization hopenpgp-tools ykman pinentry-mac

brew install nmap git tree hh

# Install more recent versions of some OS X tools
brew install vim grep openssh screen

# install public key in a remote machine's authorized_keys
brew install ssh-copy-id

# install JSON
brew install jq

# mtr - ping & traceroute. best.
brew install mtr
brew install pidcat # colored logcat guy

# Remove outdated versions from the cellar
brew cleanup
