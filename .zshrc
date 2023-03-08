# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/$USER/.oh-my-zsh"
export PATH="/usr/local/sbin:/Users/$USER/.local/flutter/bin:$PATH"

# Change them for SSH
if [[ -n $SSH_CONNECTION ]]; then
  ZSH_THEME="ys"
else
  ZSH_THEME="duellj"
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
  macos
  sudo
  web-search
  docker
)

# Init extensions
source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Directory browser and search
# Failing - source ~/z.sh

# Process the extra file (local vars)
source ~/.exports
source ~/.aliases
source ~/.functions
source ~/.extra

# https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html

# GCP Auto-Complete
if [[ -n $WORK_HOST ]]; then
  for zsh users
      source "/Users/$USER/google-cloud-sdk/path.zsh.inc"
      source "/Users/$USER/google-cloud-sdk/completion.zsh.inc"
else
  for zsh users
      source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
      source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

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

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
  

FILE=.nvmrc
if test -f "$FILE"; then
    nvm install
fi


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


