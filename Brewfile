# Brewfile - Agent-first Cloudflare development on macOS
# Usage: brew bundle --file=~/dotfiles/Brewfile

# ------------------------------------------------------------------------------
# Terminal & Shell
# ------------------------------------------------------------------------------
cask "ghostty"                          # GPU-accelerated terminal
brew "starship"                         # Cross-shell prompt
brew "zsh-autosuggestions"              # Fish-like command suggestions
brew "zsh-syntax-highlighting"          # Real-time syntax coloring
brew "zsh-history-substring-search"    # Type + Up arrow to search history
cask "font-fira-code-nerd-font"         # Nerd Font (icons for starship)

# ------------------------------------------------------------------------------
# Node.js
# ------------------------------------------------------------------------------
brew "nvm"                              # Node version manager (.nvmrc support)

# ------------------------------------------------------------------------------
# Python
# ------------------------------------------------------------------------------
brew "uv"                               # Fast Python package manager
brew "python@3.12"                      # System Python for tooling

# ------------------------------------------------------------------------------
# Git & GitHub
# ------------------------------------------------------------------------------
brew "git"
brew "gh"                               # GitHub CLI
brew "lazygit"                          # Terminal UI for git

# ------------------------------------------------------------------------------
# Containers (Cloudflare D1/R2 local dev, databases)
# ------------------------------------------------------------------------------
brew "colima"                           # Container runtime (no Docker Desktop)
brew "docker"
brew "docker-compose"

# ------------------------------------------------------------------------------
# CLI Essentials
# ------------------------------------------------------------------------------
brew "ripgrep"                          # Fast code search (rg)
brew "fd"                               # Fast file finder
brew "fzf"                              # Fuzzy finder
brew "jq"                               # JSON processing
brew "bat"                              # Syntax-highlighted cat
brew "eza"                              # Modern ls
brew "zoxide"                           # Smart directory jumping (z)

# ------------------------------------------------------------------------------
# Secrets & Identity
# ------------------------------------------------------------------------------
cask "1password"                        # Password manager
cask "1password-cli"                    # 1Password CLI (op)

# ------------------------------------------------------------------------------
# Browser
# ------------------------------------------------------------------------------
cask "google-chrome"                    # Required for Chrome DevTools MCP

# ------------------------------------------------------------------------------
# Editors & Notes
# ------------------------------------------------------------------------------
brew "neovim"                           # Quick terminal edits
cask "visual-studio-code"               # Code review & diff viewer
cask "obsidian"                         # Markdown knowledge base
