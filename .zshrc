# ------------------------------------------------------------------------------
# .zshrc - ZSH Configuration
# 
# Load order:
# 1. Exports (environment variables)
# 2. Oh My Zsh
# 3. Homebrew shell plugins
# 4. Aliases & Functions
# 5. Extra (personal overrides, not committed)
# ------------------------------------------------------------------------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ------------------------------------------------------------------------------
# Oh My Zsh Configuration
# ------------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

# Theme - using robbyrussell (default). Consider: agnoster, powerlevel10k
ZSH_THEME="robbyrussell"

# Plugins (built-in oh-my-zsh plugins only)
# External plugins (autosuggestions, syntax-highlighting) loaded via Homebrew below
plugins=(
    git           # Git aliases and functions
    docker        # Docker completions (if using Docker)
    kubectl       # Kubernetes completions (if using k8s)
)

# Oh My Zsh settings
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"  # Faster git status in large repos

# Load Oh My Zsh
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# ------------------------------------------------------------------------------
# Path Configuration
# ------------------------------------------------------------------------------

# Homebrew (Apple Silicon vs Intel)
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    HOMEBREW_PREFIX="/opt/homebrew"
else
    eval "$(/usr/local/bin/brew shellenv)"
    HOMEBREW_PREFIX="/usr/local"
fi

# Add custom bin to PATH
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# ------------------------------------------------------------------------------
# Homebrew ZSH Plugins
# ------------------------------------------------------------------------------
# These are installed via Brewfile and loaded here

# zsh-autosuggestions (fish-like suggestions)
[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-syntax-highlighting (must be last plugin loaded)
[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ------------------------------------------------------------------------------
# NVM (Node Version Manager) - Lazy Loading for faster shell startup
# ------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"

# Lazy load NVM - only initialize when first needed
nvm() {
    unset -f nvm node npm npx
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
    nvm "$@"
}

node() {
    unset -f nvm node npm npx
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
    node "$@"
}

npm() {
    unset -f nvm node npm npx
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
    npm "$@"
}

npx() {
    unset -f nvm node npm npx
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
    npx "$@"
}

# ------------------------------------------------------------------------------
# Python (uv)
# ------------------------------------------------------------------------------
# uv is installed via Homebrew, no additional config needed
# Usage: uv venv && uv pip install <package>

# ------------------------------------------------------------------------------
# FZF (Fuzzy Finder)
# ------------------------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF settings
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# ------------------------------------------------------------------------------
# Load Custom Configuration
# ------------------------------------------------------------------------------

# Load exports
[ -f ~/.exports ] && source ~/.exports

# Load aliases
[ -f ~/.aliases ] && source ~/.aliases

# Load functions
[ -f ~/.functions ] && source ~/.functions

# Load extra (personal, not committed to repo)
# This is where you put credentials, WORK_HOST, etc.
[ -f ~/.extra ] && source ~/.extra

# ------------------------------------------------------------------------------
# Completions
# ------------------------------------------------------------------------------

# Homebrew completions
if type brew &>/dev/null; then
    FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

# GitHub CLI completions
if command -v gh &>/dev/null; then
    eval "$(gh completion -s zsh)"
fi

# Wrangler completions (Cloudflare)
if command -v wrangler &>/dev/null; then
    eval "$(wrangler completions zsh 2>/dev/null)" || true
fi

# Azure CLI completions
if command -v az &>/dev/null; then
    autoload -U +X bashcompinit && bashcompinit
    source "$HOMEBREW_PREFIX/etc/bash_completion.d/az" 2>/dev/null || true
fi

# ------------------------------------------------------------------------------
# History Configuration
# ------------------------------------------------------------------------------
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

setopt HIST_IGNORE_ALL_DUPS  # Don't record duplicates
setopt HIST_FIND_NO_DUPS     # Don't show duplicates in search
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks
setopt SHARE_HISTORY         # Share history between sessions
setopt APPEND_HISTORY        # Append instead of overwrite

# ------------------------------------------------------------------------------
# Misc Settings
# ------------------------------------------------------------------------------

# Better directory navigation
setopt AUTO_CD               # cd by typing directory name
setopt AUTO_PUSHD            # Push directories to stack
setopt PUSHD_IGNORE_DUPS     # Don't push duplicates
setopt PUSHD_SILENT          # Don't print stack after pushd/popd

# Globbing
setopt EXTENDED_GLOB         # Extended globbing
setopt NO_CASE_GLOB          # Case-insensitive globbing

# ------------------------------------------------------------------------------
# SSH Agent (macOS Keychain integration)
# ------------------------------------------------------------------------------
# Ensure SSH keys are available without re-entering password
if [[ "$OSTYPE" == "darwin"* ]]; then
    ssh-add --apple-load-keychain 2>/dev/null
fi
