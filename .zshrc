# .zshrc - Agent-first Cloudflare development shell

# If not running interactively, bail
[[ $- != *i* ]] && return

# ------------------------------------------------------------------------------
# Path - Homebrew (Apple Silicon vs Intel)
# ------------------------------------------------------------------------------
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    HOMEBREW_PREFIX="/opt/homebrew"
else
    eval "$(/usr/local/bin/brew shellenv)"
    HOMEBREW_PREFIX="/usr/local"
fi

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# ------------------------------------------------------------------------------
# Prompt - Starship
# ------------------------------------------------------------------------------
eval "$(starship init zsh)"

# ------------------------------------------------------------------------------
# ZSH Plugins (via Homebrew)
# ------------------------------------------------------------------------------
[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ------------------------------------------------------------------------------
# FZF
# ------------------------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# ------------------------------------------------------------------------------
# Load custom config
# ------------------------------------------------------------------------------
[ -f ~/.exports ] && source ~/.exports
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.functions ] && source ~/.functions
[ -f ~/.extra ] && source ~/.extra        # Personal secrets, not committed

# ------------------------------------------------------------------------------
# Completions
# ------------------------------------------------------------------------------
if type brew &>/dev/null; then
    FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"
fi

autoload -Uz compinit
compinit

command -v gh &>/dev/null && eval "$(gh completion -s zsh)"
command -v wrangler &>/dev/null && eval "$(wrangler completions zsh 2>/dev/null)" || true

# ------------------------------------------------------------------------------
# History
# ------------------------------------------------------------------------------
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# ------------------------------------------------------------------------------
# Navigation
# ------------------------------------------------------------------------------
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt EXTENDED_GLOB
setopt NO_CASE_GLOB

# ------------------------------------------------------------------------------
# SSH Agent (macOS Keychain)
# ------------------------------------------------------------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
    ssh-add --apple-load-keychain 2>/dev/null
fi
