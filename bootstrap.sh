#!/usr/bin/env zsh

cd ${HOME}/dotfiles;

git pull origin master;

function doIt() {
	rsync --exclude ".git/" \
		--exclude "init" \
		--exclude "setup" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude ".macos" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . ~;
	source ~/.zshrc;
}

doIt;
unset doIt;
