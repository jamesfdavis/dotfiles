# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/$USER/.oh-my-zsh"

ZSH_THEME="ys"

# Add GPG 
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Start GPG Agent
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye 

export NOTE_REPO="expert-happiness"
export NOTE_LOCAL="/Users/$USER/Projects/$NOTE_REPO"

# Node (nvm)
# export NVM_DIR="$HOME/.nvm";
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh";

# GoLang
#export GOPATH=~/go;
#export PATH=$PATH:$(go env GOPATH)/bin;
# Brew
export PATH="/usr/local/sbin:$PATH";
# Make vim code the default editor.
export EDITOR='vim';
# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY=~/.node_history;
# Allow 32³ entries; the default is 1000.
export NODE_REPL_HISTORY_SIZE='32768';
# Use sloppy mode by default, matching web browsers.
export NODE_REPL_MODE='sloppy';

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8';

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	brew
    dotenv
	extract
	history
	last-working-dir
    osx
    sudo
	yarn
    web-search
)

# Init extensions
source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Directory browser and search
source ~/z.sh

## File shortcuts
alias d="cd ~/Documents/Dropbox"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/Projects"

## Environments
alias catn="nl -b a"
alias duck="ddg"
alias stack="stackoverflow"
alias wolf="wolframalpha"
alias gc=gcloud
alias g=git
alias h=hub
alias k=kubectl
alias v=vagrant
alias vb="VBoxManage"
alias compose="docker-compose"

## npm aliases
alias ni="npm install"
alias nrs="npm run start -s --"
alias nrb="npm run build -s --"
alias nrd="npm run dev -s --"
alias nrt="npm run test -s --"
alias nrtw="npm run test:watch -s --"
alias nrv="npm run validate -s --"
alias rnm="rm -rf node_modules"
alias flush-npm="rm -rf node_modules && npm i && echo NPM  is done"

## Utilities
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend" # Lock the screen (when going AFK)
alias c="tr -d '\n' | pbcopy"
alias df="df -h"
alias du="du -hd1 | sort -h"
alias usage="du -h -d1"
alias runp="lsof -i"
alias update="source ~/.zshrc"
alias upgrade='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; sudo gem update --system; sudo gem update; sudo gem cleanup'
alias path='echo -e ${PATH//:/\\n}'
alias reload="exec ${SHELL} -l"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)'"
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"
alias pip=pip3

# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Search local notes by filename.
function name() {
	find $NOTE_LOCAL -name "*$1*"
}

# Search local note contents.
function fix() {
	grep -r "FIX" $NOTE_LOCAL/$1* | sed  "s/\/Users\/$USER\/Projects\/$NOTE_REPO\//Fix : /g" | mdcat | catn
}


# Generate todo list.
function todo() {
	rm $NOTE_LOCAL/todo.txt
	grep -r 'TODO' --exclude=todo.txt $NOTE_LOCAL/$1* | sed  "s/\/Users\/$USER\/Projects\/$NOTE_REPO\//To Do : /g" >> $NOTE_LOCAL/todo.txt
	mdcat $NOTE_LOCAL/todo.txt | catn
}

# Search local note contents.
function notes() {
	grep -ri "$*" --exclude=todo.txt $NOTE_LOCAL/ | sed  "s/\/Users\/$USER\/Projects\/$NOTE_REPO\/\// Notes : /g" | mdcat | catn | grep -ri "$*" 
}

# Create a new note
function note() {
	if [ -z "$*" ]
	then
		echo "File name is empty!"
	else
		title=notes
		today=$(date +"%Y-%m-%d")
		newly="$NOTE_LOCAL$meeting/$title/$today-$*.md"
		echo "$newly" | sed  "s/ /-/g" | awk '{print tolower($0)}'
	fi
}

# Create new meeting
function meet() {
	if [ -z "$*" ]
	then
		echo "File name is empty!"
	else
		title=meeting
		today=$(date +"%Y-%m-%d")
		newly="$NOTE_LOCAL$meeting/$title/$today-$*.md"
		echo "$newly" | sed  "s/ /-/g" | awk '{print tolower($0)}'
	fi
}

# Load KeyCard
function loadcard() {
	unset GNUPGHOME

	if [ ! -z $(ykman info | grep -o '[0-9][0-9]*[0-9]') ]
		export GNUPGHOME="/Users/$USER/Documents/Dropbox/Private/pki/card-$(ykman info | grep -o '[0-9][0-9]*[0-9]')"
		return
}

# GPG
secret () {
        output=~/"${1}".$(date +%s).enc
        gpg --encrypt --armor --output ${output} -r 0x0000 -r 0x0001 -r 0x0002 "${1}" && echo "${1} -> ${output}"
}

reveal () {
        output=$(echo "${1}" | rev | cut -c16- | rev)
        gpg --decrypt --output ${output} "${1}" && echo "${1} -> ${output}"
}

# Recursive find and replace inline.
# find . -type f -name '*.md' -print0 | xargs -0 sed -i '' -e "s/this/that/g"

# Replace something inside a git repo.
replace () {
 if [ ! -z $(git rev-parse --is-inside-work-tree) ]; then $(find . -type f -name "*.md" -print0 | xargs -0 sed -i '' -e "s/$1/$2/g"); fi
}
# `s` with no arguments opens the curcdrent directory in VS Code, otherwise
# opens the given location
function code() {
	if [ $# -eq 0 ]; then
		/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code .;
	else
		/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code "$@";
	fi;
}

function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Compare original and gzipped file size
function gz() {
	local origsize=$(wc -c < "$1");
	local gzipsize=$(gzip -c "$1" | wc -c);
	local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
	printf "orig: %d bytes\n" "$origsize";
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified.";
		return 1;
	fi;

	local domain="${1}";
	echo "Testing ${domain}…";
	echo ""; # newline

	local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
		| openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version");
		echo "Common Name:";
		echo ""; # newline
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
		echo ""; # newline
		echo "Subject Alternative Name(s):";
		echo ""; # newline
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
		return 0;
	else
		echo "ERROR: Certificate not found.";
		return 1;
	fi;
}

# Save python dependencies
function  pip_install_save() {
    package_name=$1
    requirements_file=$2
    if [[ -z $requirements_file ]]
    then
        requirements_file='./requirements.txt'
    fi
    pip install $package_name && pip freeze | grep -i $package_name >> $requirements_file
}

function tre() {
	tree -aC -L 4 -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# Process the extra file (local vars)
source ~/.extra

# https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html

# GCP Auto-Complete
for zsh users
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# Node version manager.
 export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Kube resources from gcloud libraries.
source <(kubectl completion zsh)
complete -F __start_kubectl k

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 2>/dev/null ) )
}
complete -o default -F _pip_completion pip3
# pip bash completion end
