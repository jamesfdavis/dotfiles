# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/$USER/.oh-my-zsh"

# Change them for SSH
if [[ -n $SSH_CONNECTION ]]; then
  ZSH_THEME="jonathan"
else
  ZSH_THEME="sorin"
fi

# Add GPG 
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Start GPG Agent
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye 

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(
	brew
    dotenv
    osx
    sudo
    web-search
)

# Init extensions
source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh



# Directory browser and search
source ~/z.sh

# Process the extra file (local vars)
source ~/.exports
source ~/.aliases
source ~/.functions
source ~/.extra

# https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html

# GCP Auto-Complete
for zsh users
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

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

