# Brewfile - Declarative package management for macOS
# Usage: brew bundle --file=~/dotfiles/Brewfile
# 
# Last updated: 2026 MBP Refresh
# Primary focus: Claude Code + Cloudflare + Python/Jupyter

# ------------------------------------------------------------------------------
# Taps
# ------------------------------------------------------------------------------
tap "cloudflare/cloudflare"

# ------------------------------------------------------------------------------
# Core CLI Tools
# ------------------------------------------------------------------------------
brew "git"                      # Version control
brew "gh"                       # GitHub CLI
brew "jq"                       # JSON processing
brew "yq"                       # YAML processing
brew "ripgrep"                  # Fast search (rg) - better than grep
brew "fzf"                      # Fuzzy finder
brew "tree"                     # Directory visualization
brew "wget"                     # File downloads
brew "curl"                     # HTTP client (newer than system)
brew "htop"                     # Process viewer
brew "bat"                      # Better cat with syntax highlighting
brew "eza"                      # Modern ls replacement (formerly exa)
brew "fd"                       # Better find

# ------------------------------------------------------------------------------
# Development - Node.js
# ------------------------------------------------------------------------------
brew "nvm"                      # Node version manager
# Note: After install, add NVM setup to .zshrc (already configured)
# Then: nvm install --lts

# ------------------------------------------------------------------------------
# Development - Python
# ------------------------------------------------------------------------------
brew "uv"                       # Fast Python package manager (replaces pip/conda)
brew "python@3.12"              # System Python for tooling
# Note: Use 'uv' for project environments
# Example: uv venv && uv pip install jupyter pandas numpy

# ------------------------------------------------------------------------------
# Cloud & Deployment
# ------------------------------------------------------------------------------
brew "cloudflare/cloudflare/cloudflared"  # Cloudflare Tunnel
brew "wrangler"                 # Cloudflare Workers CLI
brew "azure-cli"                # Azure CLI (for CSI work)

# ------------------------------------------------------------------------------
# Shell Enhancement
# ------------------------------------------------------------------------------
brew "zsh-autosuggestions"      # Fish-like autosuggestions
brew "zsh-syntax-highlighting"  # Syntax highlighting in terminal

# ------------------------------------------------------------------------------
# Casks - GUI Applications
# ------------------------------------------------------------------------------
cask "iterm2"                   # Terminal emulator
cask "visual-studio-code"       # Code editor
cask "claude"                   # Claude desktop app
cask "font-fira-code-nerd-font" # Nerd Font with ligatures + icons

# ------------------------------------------------------------------------------
# Optional - Uncomment if needed
# ------------------------------------------------------------------------------
# cask "docker"                 # Container runtime
# cask "postman"                # API testing
# cask "raycast"                # Spotlight replacement
# cask "1password-cli"          # 1Password CLI (op)
# brew "tmux"                   # Terminal multiplexer
# brew "neovim"                 # Modern vim

# ------------------------------------------------------------------------------
# VS Code Extensions (installed via setup-vscode.sh, listed here for reference)
# ------------------------------------------------------------------------------
# See: vscode/extensions.txt
