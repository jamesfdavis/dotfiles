#!/usr/bin/env zsh
# Modern .zshrc Configuration for 2025
# Optimized for Apple Silicon and Intel Macs

#==============================================================================
# Performance Optimization (Load Early)
#==============================================================================

# Skip global compinit for faster startup (Oh My Zsh will handle it)
skip_global_compinit=1

# Measure startup time (uncomment for debugging)
# zmodload zsh/zprof

#==============================================================================
# Oh My Zsh Configuration
#==============================================================================

# Path to Oh My Zsh installation (cross-platform)
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    export ZSH="$HOME/.oh-my-zsh"
else
    echo "Warning: Oh My Zsh not found. Install with:"
    echo 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
    return
fi

# Theme configuration (improved logic)
if [[ -n $SSH_CONNECTION ]]; then
    ZSH_THEME="ys"           # Remote sessions
elif [[ -n $TMUX ]]; then
    ZSH_THEME="refined"      # Tmux sessions (minimal)
else
    # Use a simpler theme that doesn't require special fonts
    ZSH_THEME="robbyrussell"  # Default, clean theme
fi

# Oh My Zsh settings
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
DISABLE_UPDATE_PROMPT="false"
export UPDATE_ZSH_DAYS=7
DISABLE_MAGIC_FUNCTIONS="false"
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"

# Modern plugins (optimized selection)
plugins=(
    # Core functionality
    git
    brew
    macos
    sudo

    # Development
    docker
    docker-compose
    kubectl
    terraform
    node
    npm
    python
    pip
    golang
    rust

    # Productivity
    fzf
    z
    web-search
    extract
    colored-man-pages
    copypath
    copyfile

    # Enhanced features
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
)

#==============================================================================
# Homebrew & PATH Configuration
#==============================================================================

# Homebrew setup (Apple Silicon + Intel compatibility)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    # Apple Silicon Mac
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -f "/usr/local/bin/brew" ]]; then
    # Intel Mac
    eval "$(/usr/local/bin/brew shellenv)"
    export HOMEBREW_PREFIX="/usr/local"
fi

# Enhanced PATH configuration
typeset -U path  # Remove duplicates
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.cargo/bin"              # Rust
    "$HOME/go/bin"                  # Go
    "$HOME/.pub-cache/bin"          # Dart/Flutter
    "/opt/homebrew/bin"             # Apple Silicon Homebrew
    "/opt/homebrew/sbin"
    "/usr/local/bin"                # Intel Homebrew
    "/usr/local/sbin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
    $path
)

# Export the path
export PATH

#==============================================================================
# Development Environment Setup
#==============================================================================

# Node.js (NVM)
export NVM_DIR="$HOME/.nvm"
if [[ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ]]; then
    source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
    source "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm"

    # Auto-load .nvmrc
    autoload -U add-zsh-hook
    load-nvmrc() {
        local nvmrc_path="$(nvm_find_nvmrc)"
        if [[ -n "$nvmrc_path" ]]; then
            local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
            if [[ "$nvmrc_node_version" = "N/A" ]]; then
                nvm install
            elif [[ "$nvmrc_node_version" != "$(nvm version)" ]]; then
                nvm use
            fi
        elif [[ "$(nvm version)" != "$(nvm version default)" ]]; then
            echo "Reverting to nvm default version"
            nvm use default
        fi
    }
    add-zsh-hook chpwd load-nvmrc
    load-nvmrc
fi

# Python (pyenv)
if command -v pyenv 1>/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    path=("$PYENV_ROOT/bin" $path)
    eval "$(pyenv init -)"
fi

# Ruby (rbenv)
if command -v rbenv 1>/dev/null 2>&1; then
    eval "$(rbenv init - zsh)"
fi

# Go configuration
export GOPATH="$HOME/go"
export GOROOT="${HOMEBREW_PREFIX}/opt/go/libexec"

# Rust configuration
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Java configuration
if [[ -d "${HOMEBREW_PREFIX}/opt/openjdk" ]]; then
    export PATH="${HOMEBREW_PREFIX}/opt/openjdk/bin:$PATH"
    export JAVA_HOME="${HOMEBREW_PREFIX}/opt/openjdk"
fi

#==============================================================================
# Security & GPG Configuration
#==============================================================================

# GPG configuration
export GPG_TTY="$(tty)"
export GNUPGHOME="$HOME/.gnupg"

# GPG agent setup (with error handling)
if command -v gpgconf &>/dev/null && command -v gpg-agent &>/dev/null; then
    # Only set up GPG if it's properly configured
    if gpgconf --list-dirs &>/dev/null; then
        export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket 2>/dev/null)"

        # Start GPG agent if not running
        if ! pgrep -x "gpg-agent" > /dev/null; then
            gpgconf --launch gpg-agent &>/dev/null || true
        fi

        # Update TTY for GPG
        gpg-connect-agent updatestartuptty /bye &>/dev/null || true
    fi
fi

#==============================================================================
# Load Oh My Zsh
#==============================================================================

source $ZSH/oh-my-zsh.sh

#==============================================================================
# Enhanced Shell Features
#==============================================================================

# Zsh syntax highlighting (if not loaded by plugin)
if [[ ! " ${plugins[@]} " =~ " zsh-syntax-highlighting " ]]; then
    ZSH_HIGHLIGHT_PATH="${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    [[ -f "$ZSH_HIGHLIGHT_PATH" ]] && source "$ZSH_HIGHLIGHT_PATH"
fi

# Zsh autosuggestions (if not loaded by plugin)
if [[ ! " ${plugins[@]} " =~ " zsh-autosuggestions " ]]; then
    ZSH_AUTOSUGGESTIONS_PATH="${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [[ -f "$ZSH_AUTOSUGGESTIONS_PATH" ]] && source "$ZSH_AUTOSUGGESTIONS_PATH"
fi

# FZF configuration
if command -v fzf &>/dev/null; then
    if [[ -f "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh" ]]; then
        source "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh"
        source "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh"
    fi

    # FZF configuration
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_DEFAULT_OPTS='
        --height 40%
        --layout=reverse
        --border
        --preview "bat --style=numbers --color=always --line-range :500 {}"
        --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
        --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
        --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
        --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
fi

# Zoxide (better cd)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

#==============================================================================
# Cloud Tools & APIs
#==============================================================================

# Google Cloud SDK
GCLOUD_PATHS=(
    "$HOME/google-cloud-sdk"
    "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
    "/opt/google-cloud-sdk"
)

for gcloud_path in "${GCLOUD_PATHS[@]}"; do
    if [[ -d "$gcloud_path" ]]; then
        source "$gcloud_path/path.zsh.inc"
        source "$gcloud_path/completion.zsh.inc"
        break
    fi
done

# Kubernetes completion
if command -v kubectl &>/dev/null; then
    source <(kubectl completion zsh)
    alias k=kubectl
    complete -F __start_kubectl k
fi

# Docker completion (zsh compatible)
if command -v docker &>/dev/null; then
    # Use docker's built-in completion for zsh
    if [[ ! -f ~/.zcompdump ]] || [[ ~/.zcompdump -ot $(which docker) ]]; then
        docker completion zsh > ~/.docker-completion.zsh 2>/dev/null || true
    fi
    
    if [[ -f ~/.docker-completion.zsh ]]; then
        source ~/.docker-completion.zsh
    fi
fi

# AWS CLI completion
if command -v aws &>/dev/null; then
    autoload bashcompinit && bashcompinit
    complete -C aws_completer aws
fi

# Terraform completion
if command -v terraform &>/dev/null; then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C terraform terraform
    alias tf=terraform
fi

#==============================================================================
# Conda/Miniconda Setup
#==============================================================================

# Conda initialization (improved version)
CONDA_PATHS=(
    "${HOMEBREW_PREFIX}/Caskroom/miniconda/base"
    "$HOME/miniconda3"
    "$HOME/anaconda3"
    "/opt/miniconda3"
)

for conda_path in "${CONDA_PATHS[@]}"; do
    if [[ -f "$conda_path/bin/conda" ]]; then
        __conda_setup="$('$conda_path/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "$conda_path/etc/profile.d/conda.sh" ]; then
                source "$conda_path/etc/profile.d/conda.sh"
            else
                export PATH="$conda_path/bin:$PATH"
            fi
        fi
        unset __conda_setup
        break
    fi
done

#==============================================================================
# Custom Configuration Files
#==============================================================================

# Source additional configuration files (with error handling)
config_files=(
    "$HOME/.exports"
    "$HOME/.aliases"
    "$HOME/.functions"
    "$HOME/.extra"
    "$HOME/.zshrc.local"
)

for config_file in "${config_files[@]}"; do
    [[ -r "$config_file" ]] && source "$config_file"
done

#==============================================================================
# History Configuration
#==============================================================================

# Extended history settings
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY          # Write timestamps to history
setopt SHARE_HISTORY            # Share history between sessions
setopt APPEND_HISTORY           # Append rather than overwrite
setopt INC_APPEND_HISTORY       # Add commands as they are typed
setopt HIST_IGNORE_DUPS         # Ignore duplicate entries
setopt HIST_IGNORE_ALL_DUPS     # Remove old duplicates
setopt HIST_SAVE_NO_DUPS        # Don't save duplicates
setopt HIST_IGNORE_SPACE        # Ignore commands starting with space
setopt HIST_FIND_NO_DUPS        # No duplicates in search
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks
setopt HIST_VERIFY              # Show expanded history before execution

#==============================================================================
# Completion Enhancement
#==============================================================================

# Modern completion settings
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'

# Kill command completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

#==============================================================================
# Modern Aliases & Functions
#==============================================================================

# Enhanced ls with colors (use eza if available)
if command -v eza &>/dev/null; then
    alias ls='eza --group-directories-first --icons'
    alias ll='eza -la --group-directories-first --icons --git'
    alias lt='eza --tree --level=2 --icons'
else
    alias ls='ls --color=auto'
    alias ll='ls -la'
    alias la='ls -A'
fi

# Modern Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# System utilities
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias mkdir='mkdir -pv'
alias path='echo -e ${PATH//:/\\n}'

# Development shortcuts
alias python='python3'
alias pip='pip3'
alias vim='nvim'

#==============================================================================
# Powerlevel10k Configuration
#==============================================================================

# Enable Powerlevel10k instant prompt (should stay close to the top of the file)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#==============================================================================
# Final Setup & Cleanup
#==============================================================================

# Remove duplicates from PATH
typeset -U PATH

# Welcome message (optional)
if [[ -o interactive ]] && [[ -z "$TMUX" ]] && [[ -z "$SSH_CONNECTION" ]]; then
    echo "🚀 Modern Zsh configuration loaded!"
    echo "📦 $(echo $plugins | wc -w | xargs) plugins active"
    command -v git &>/dev/null && echo "📂 $(basename "$PWD")" || true
fi

# Performance profiling (uncomment to see startup time)
# zprof
