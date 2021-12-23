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

# Do a Software Update on the MBP; completes xcode install.

###
##############################################################################################################


##############################################################################################################
### cargo - rust package manager
# https://doc.rust-lang.org/cargo/getting-started/installation.html
 
# install
curl https://sh.rustup.rs -sSf | sh

./cargo.sh

###
##############################################################################################################


##############################################################################################################
### homebrew!

# install all the things!

# Download and install the JRE
# https://www.java.com/en/download/

./brew.sh
./brew-cask.sh
./npm.sh
# Start up ssh client

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye 

# Git Projects Folder
# mkdir ~/Projects

### end of homebrew
##############################################################################################################


##############################################################################################################
### oh-my-zsh!

# prezto and antigen communties also have great stuff
#   github.com/sorin-ionescu/prezto/blob/master/modules/utility/init.zsh

cd $HOME
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" # Install zsh
wget https://raw.githubusercontent.com/jamesfdavis/dotfiles/master/.zshrc

# Setup permissions
chmod 755 /usr/local/share/zsh
chmod 755 /usr/local/share/zsh/site-functions

# Zed
curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/plugins/z/z.sh 
# Make z.sh executable
chmod +x ~/z.sh

### end of VS
##############################################################################################################


##############################################################################################################
### Visual Studio Code
 
# ./vscode.sh

### end of VS
##############################################################################################################


##############################################################################################################
### Vim Setup
 
mkdir ~/.vim/
mkdir ~/.vim/backups
mkdir ~/.vim/swaps
mkdir ~/.vim/undo

### end of Vim
##############################################################################################################


##############################################################################################################
### GnuPG Setup (rework this)

# mkdir ~/.gnupg
# cp ./init/gpg-agent.conf ~/.gnupg/gpg-agent.conf

# # Setup permissions
# find ~/.gnupg -type f -exec chmod 600 {} \;
# find ~/.gnupg -type d -exec chmod 700 {} \;


# gpg --import ~/Downloads/yubikey-pubkey.txt
# gpg --edit-key $KEYID

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
### Make the common things
###
  
mkdir ~/bin # Local binaries
mkdir ~/etc # Host-specific system configuration for local binaries
mkdir ~/lib # Local libraries
mkdir ~/lib64 # Local 64-bit libraries
mkdir ~/man # Local online manuals
mkdir ~/sbin # Local system binaries
mkdir ~/share # Local architecture-independent hierarchy
mkdir ~/src # Local source code (Git Repos)

###
##############################################################################################################


##############################################################################################################
### Remaining configuration
###

# go read mathias, paulmillr, gf3, alraa's dotfiles to see what's worth stealing.

# set up Mac OS defaults
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos
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

ln -s ~/src/dotfiles ~/dotfiles

# Redeploy dotfiles to $HOME
# sh bootstrap

###
##############################################################################################################
