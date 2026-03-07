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

[ -f "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ] && \
    source "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ------------------------------------------------------------------------------
# Sudo widget (double-tap Esc to toggle sudo prefix)
# ------------------------------------------------------------------------------
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

# ------------------------------------------------------------------------------
# NVM - Lazy loading for fast shell startup
# ------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"

# Eagerly add default node to PATH (child processes like Neovim Mason need npm)
_nvm_default="$NVM_DIR/versions/node/$(ls "$NVM_DIR/versions/node" 2>/dev/null | sort -V | tail -1)/bin"
[[ -d "$_nvm_default" ]] && export PATH="$_nvm_default:$PATH"
unset _nvm_default

# Lazy load NVM: only initialize when first called
_nvm_lazy_init() {
    unset -f nvm node npm npx claude _nvm_lazy_init
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
}
nvm() { _nvm_lazy_init; nvm "$@"; }
node() { _nvm_lazy_init; node "$@"; }
npm() { _nvm_lazy_init; npm "$@"; }
npx() { _nvm_lazy_init; npx "$@"; }
claude() { _nvm_lazy_init; claude "$@"; }

# Auto-switch Node version when entering a directory with .nvmrc
_nvm_auto_use() {
    if [ -f ".nvmrc" ]; then
        # If NVM_BIN is empty, NVM hasn't been fully loaded yet
        if [ -z "$NVM_BIN" ]; then
            unset -f nvm node npm npx claude _nvm_lazy_init 2>/dev/null
            [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
        fi
        local nvmrc_node_version=$(cat .nvmrc)
        local current_node_version=$(node -v 2>/dev/null)
        if [ "$current_node_version" != "$nvmrc_node_version" ] && \
           [ "$current_node_version" != "v${nvmrc_node_version}" ]; then
            nvm use 2>/dev/null || nvm install
        fi
    fi
}
autoload -U add-zsh-hook
add-zsh-hook chpwd _nvm_auto_use
# Run once on shell start if .nvmrc exists in cwd
_nvm_auto_use

# ------------------------------------------------------------------------------
# FZF
# ------------------------------------------------------------------------------
eval "$(fzf --zsh 2>/dev/null)" || { [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh; }
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# ------------------------------------------------------------------------------
# Zoxide (smart cd)
# ------------------------------------------------------------------------------
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# ------------------------------------------------------------------------------
# Load custom config
# ------------------------------------------------------------------------------
[ -f ~/.exports ] && source ~/.exports
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.functions ] && source ~/.functions
[ -f ~/.extra ] && source ~/.extra        # Personal secrets, not committed

# ------------------------------------------------------------------------------
# Completions (cached - regenerates once per day)
# ------------------------------------------------------------------------------
if type brew &>/dev/null; then
    FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"
fi

autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

command -v gh &>/dev/null && eval "$(gh completion -s zsh)"
command -v wrangler &>/dev/null && eval "$(wrangler complete zsh 2>/dev/null)" || true

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
export GPG_TTY=$(tty)
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
