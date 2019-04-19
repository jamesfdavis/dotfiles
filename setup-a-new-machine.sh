# copy paste this file in bit by bit.
# don't run it.
  echo "do not run this script in one go. hit ctrl-c NOW"
  read -n 1

##############################################################################################################
### XCode Command Line Tools
#      thx https://github.com/alrra/dotfiles/blob/ff123ca9b9b/os/os_x/installs/install_xcode.sh

if ! xcode-select --print-path &> /dev/null; then

    # Prompt user to install the XCode Command Line Tools
    xcode-select --install &> /dev/null

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait until the XCode Command Line Tools are installed
    until xcode-select --print-path &> /dev/null; do
        sleep 5
    done

    # print_result $? 'Install XCode Command Line Tools'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Point the `xcode-select` developer directory to
    # the appropriate directory from within `Xcode.app`
    # https://github.com/alrra/dotfiles/issues/13

    sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
    # print_result $? 'Make "xcode-select" developer directory point to Xcode'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Prompt user to agree to the terms of the Xcode license
    # https://github.com/alrra/dotfiles/issues/10

    sudo xcodebuild -license
    # print_result $? 'Agree with the XCode Command Line Tools licence'

fi
###
##############################################################################################################


##############################################################################################################
### homebrew!

# (if your machine has /usr/local locked down (like google's), you can do this to place everything in ~/.homebrew
# mkdir $HOME/.homebrew && curl -L https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew
# export PATH=$HOME/.homebrew/bin:$HOME/.homebrew/sbin:$PATH

# Install Brew

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install all the things
./brew.sh
./brew-cask.sh

### end of homebrew
##############################################################################################################


##############################################################################################################
### Visual Studio
 
# ./vscode.sh

### end of VS
##############################################################################################################


##############################################################################################################
### Vim Setup
 
mkdir ~/.vim/
mkdir ~/.vim/backups
mkdir ~/.vim/tmp
mkdir ~/.vim/undo

### end of VS
##############################################################################################################


##############################################################################################################
### GnuPG Setup

mkdir ~/.gnupg
cp ./init/gpg-agent.conf ~/.gnupg/gpg-agent.conf

# Setup permissions
find ~/.gnupg -type f -exec chmod 600 {} \;
find ~/.gnupg -type d -exec chmod 700 {} \;

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

gpg --import ~/Downloads/yubikey-pubkey.txt
gpg --edit-key $KEYID

# Trust public cert.
# gpg>trust

# https://help.github.com/articles/generating-a-new-gpg-key/
# https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work

# Generate GPG Key
# gpg --full-generate-key
# gpg --armor --export # "sec id"

### end of GitHub
##############################################################################################################


##############################################################################################################
### install of common things
###

# NVM - Node Version Manager
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# github.com/jamiew/git-friendly
# the `push` command which copies the github compare URL to my clipboard is heaven
# bash < <( curl https://raw.githubusercontent.com/jamiew/git-friendly/master/install.sh)

# # Type `git open` to open the GitHub page or website for a repository.
# npm install -g git-open

# # fancy listing of recent branches
# npm install -g git-recent

# # sexy Git diffs
# npm install -g diff-so-fancy

# # browser sync, for dev
# npm install -g browser-sync
# npm install -g concurrently

# # trash as the safe `rm` alternative
# npm install --global trash-cli

# # Node version selector
# # npm install --global n (nvm instead)
# # npm install --global yarn (depcicated by npm 5)
# npm install -g install-peerdeps #eslint vscode support

# # Git Open Repo
# npm install --global git-open

# # Git Recent
# npm install --global git-recent

# # local development 
# npm install --global foreman
# npm install --global nodemon
# # npm install -g node-inspector # Deprecated in 6.3

# # local npm 
# npm install -g local-npm

# # local weather
# npm i -g cli-weather
# npm i -g google-maps-direction-cli

# simpler man pages
# npm install -g tldr

# npm install -g clinic
# npm install -g autocannon

# github.com/rupa/z   - oh how i love you
# git clone https://github.com/rupa/z.git ~/code/z
# consider reusing your current .z file if possible. it's painful to rebuild :)
# z is hooked up in .bash_profile

mkdir ~/Projects

# sudo easy_install pip
# sudo pip install virtualenv

# # github.com/thebitguru/play-button-itunes-patch
# # disable itunes opening on media keys
# # git clone https://github.com/thebitguru/play-button-itunes-patch ~/code/play-button-itunes-patch

# # my magic photobooth symlink -> dropbox. I love it.
# # 	 + first move Photo Booth folder out of Pictures
# # 	 + then start Photo Booth. It'll ask where to put the library.
# # 	 + put it in Dropbox/public
# # 	* Now… you can record photobooth videos quickly and they upload to dropbox DURING RECORDING
# # 	* then you grab public URL and send off your video message in a heartbeat.

# # for the c alias (syntax highlighted cat)
# sudo easy_install Pygments

# # Markdown docs in terminal
# # http://brettterpstra.com/2015/08/21/mdless-better-markdown-in-terminal/

# sudo gem install mdless

# sudo gem install ghi

# # change to bash 4 (installed by homebrew)
# BASHPATH=$(brew --prefix)/bin/bash
# #sudo echo $BASHPATH >> /etc/shells
# sudo bash -c 'echo $(brew --prefix)/bin/bash >> /etc/shells'
# chsh -s $BASHPATH # will set for current user only.
# echo $BASH_VERSION # should be 4.x not the old 3.2.X
# # Later, confirm iterm settings aren't conflicting.


# iterm with more margin! http://hackr.it/articles/prettier-gutter-in-iterm-2/
#   (admittedly not as easy to maintain)

# setting up the sublime symlink
# cd /usr/local/bin && ln -sf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" subl && cd -

###
##############################################################################################################


##############################################################################################################
### remaining configuration
###

# go read mathias, paulmillr, gf3, alraa's dotfiles to see what's worth stealing.

# prezto and antigen communties also have great stuff
#   github.com/sorin-ionescu/prezto/blob/master/modules/utility/init.zsh

# set up osx defaults
#   maybe something else in here https://github.com/hjuutilainen/dotfiles/blob/master/bin/osx-user-defaults.sh
sh .macos

# Enable firewall, stealth mode.
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on


###
##############################################################################################################


##############################################################################################################
### symlinks to link dotfiles into ~/
###

#   move git credentials into ~/.gitconfig.local    	http://stackoverflow.com/a/13615531/89484
#   now .gitconfig can be shared across all machines and only the .local changes


# bootstrap it up!
./bootstrap.sh

###
##############################################################################################################
