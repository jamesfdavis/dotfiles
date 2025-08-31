#!/bin/zsh

# Modern Software Engineering Brew Setup
# Updated for 2025 development workflows
# Combines best practices from multiple sources

echo "🚀 Starting Comprehensive Software Engineering Brew Setup..."

# Update Homebrew
echo "📦 Updating Homebrew..."
brew update && brew upgrade

###############################################################################
# System Utilities & GNU Tools                                               #
###############################################################################

echo "🔧 Installing system utilities and GNU tools..."

# GNU core utilities (better than macOS defaults)
brew install coreutils
brew install moreutils
brew install findutils
brew install gnu-sed
brew install grep
brew install openssh
brew install screen
brew install vim

# System monitoring
brew install htop
brew install mtr           # Better ping & traceroute
brew install nmap          # Network scanning

# Text processing
brew install ack           # Better grep
brew install grc           # Generic colorizer
brew install jq            # JSON processor
brew install yq            # YAML processor

###############################################################################
# Essential Development Tools (CLI)                                          #
###############################################################################

echo "🛠️  Installing essential development CLI tools..."

# Core development tools
brew install git
brew install gh            # GitHub CLI
brew install node
brew install python@3.12
brew install go
brew install rust
brew install java
brew install maven
brew install gradle

# Essential CLI utilities
brew install curl
brew install wget          # With IRI support
brew install tree          # Directory listing
brew install bat           # Better cat
brew install fd            # Better find
brew install ripgrep       # Better grep
brew install fzf           # Fuzzy finder
brew install zoxide        # Better cd
brew install tldr          # Better man pages
brew install ncdu          # Disk usage analyzer

# Security & certificates
brew install gnupg         # PGP signing
brew install mkcert        # Local certificates
brew install certbot       # Let's Encrypt certificates

# Database tools
brew install postgresql@15
brew install redis
brew install mongodb/brew/mongodb-community

# Container & Orchestration
brew install docker
brew install docker-compose
brew install kubernetes-cli
brew install helm
brew install k9s           # Kubernetes dashboard

# Infrastructure as Code
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew install hashicorp/tap/packer
brew install hashicorp/tap/vault
brew install ansible

# Cloud CLI tools
brew install awscli
brew install azure-cli
brew install google-cloud-sdk

# Performance testing
brew install vegeta        # HTTP load testing
brew tap rs/tap
brew install rs/tap/jaggr  # JSON aggregation
brew install rs/tap/jplot  # JSON plotting

# Network & tunneling
brew install ngrok         # Tunneling
brew install ssh-copy-id   # SSH key deployment

# Version managers
brew install nvm           # Node version manager
brew install pyenv         # Python version manager
brew install rbenv         # Ruby version manager


###############################################################################
# Development Applications                                                    #
###############################################################################

echo "📱 Installing development applications..."

# Core development
brew install --cask visual-studio-code
brew install --cask iterm2

# Browsers for testing
brew install --cask google-chrome
brew install --cask firefox
brew install --cask brave-browser
brew install --cask arc

# Database management
brew install --cask tableplus
brew install --cask mongodb-compass

# API development & testing
brew install --cask postman
brew install --cask insomnia

# Design & prototyping
brew install --cask figma
brew install --cask sketch

# Mobile development
brew install --cask android-studio
brew install --cask flutter

# Virtualization & containers
brew install --cask docker
brew install --cask orbstack       # Lightweight Docker Desktop alternative
brew install --cask utm            # Modern VM management

###############################################################################
# Data Science & Scientific Computing                                        #
###############################################################################

echo "📊 Installing data science tools..."

# Python scientific computing
brew install --cask miniconda
brew install jupyter

# R for statistical computing
brew install r

# Data visualization
brew install graphviz       # For diagrams.mingrammer.com

###############################################################################
# Productivity & Communication                                                #
###############################################################################

echo "💬 Installing productivity and communication tools..."

# Communication
brew install --cask slack
brew install --cask zoom

# Productivity & writing
brew install --cask obsidian       # Note-taking

# System utilities
brew install --cask raycast        # Better Spotlight
brew install --cask rectangle      # Window management
brew install --cask alfred         # Advanced launcher

# File management & sync
brew install --cask google-drive

# Security & passwords
brew install --cask 1password

###############################################################################
# Specialized Development Tools                                               #
###############################################################################

echo "🎯 Installing specialized development tools..."

# System monitoring & debugging
brew install --cask stats          # System monitor in menu bar
brew install pidcat               # Colored Android logcat

# Network debugging
brew install --cask proxyman       # HTTP debugging proxy
brew install --cask wireshark

# Geographic & mapping
brew install --cask google-earth-pro

###############################################################################
# Media & Content Creation                                                    #
###############################################################################

echo "🎨 Installing media tools..."

# Screen recording & screenshots
brew install --cask cleanshot      # Better screenshot tool
brew install --cask kap            # Screen recording

# Image optimization
brew install imagemagick
brew install --cask imageoptim

###############################################################################
# Shell Enhancement (Zsh)                                                     #
###############################################################################

echo "🐚 Installing Zsh enhancements..."

# Zsh plugins
brew install zsh-syntax-highlighting
brew install zsh-autosuggestions

# Oh My Zsh installation (if not already installed)
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

###############################################################################
# VS Code Extensions Setup                                                    #
###############################################################################

echo "🔧 Installing essential VS Code extensions..."

# Wait for VS Code to be available
sleep 2

# Core extensions
code --install-extension ms-python.python
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension esbenp.prettier-vscode
code --install-extension ms-vscode.vscode-eslint
code --install-extension bradlc.vscode-tailwindcss
code --install-extension ms-vscode.vscode-git
code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-azuretools.vscode-docker
code --install-extension hashicorp.terraform
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension golang.go
code --install-extension rust-lang.rust-analyzer
code --install-extension redhat.java
code --install-extension ms-python.black-formatter

# Mobile development
code --install-extension dart-code.flutter
code --install-extension dart-code.dart-code

###############################################################################
# System Configuration                                                        #
###############################################################################

echo "⚙️  Configuring system services and environment..."

# Start essential services
brew services start postgresql@15
brew services start redis

# Create useful directories
mkdir -p ~/Development/{personal,work,playground,mobile}
mkdir -p ~/Development/scripts

# Configure Zsh plugins in .zshrc if not already configured
if ! grep -q "zsh-syntax-highlighting" ~/.zshrc 2>/dev/null; then
    echo "" >> ~/.zshrc
    echo "# Zsh plugins" >> ~/.zshrc
    echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
    echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
fi

# Set up conda environment for data science (commented out by default)
echo ""
echo "📊 To set up data science environment, run:"
echo "   conda init \"\$(basename \"\${SHELL}\")\""
echo "   conda create -n jupyter-env jupyter pandas numpy matplotlib"
echo "   conda activate jupyter-env"

###############################################################################
# Cleanup & Summary                                                           #
###############################################################################

echo "🧹 Cleaning up..."
brew cleanup

echo ""
echo "✅ Comprehensive Software Engineering Setup Complete!"
echo ""
echo "📦 Installed Categories:"
echo "   • GNU/System utilities (coreutils, findutils, gnu-sed)"
echo "   • Development CLI tools (git, gh, node, python, go, rust, java)"
echo "   • Container tools (Docker, Kubernetes, Helm, k9s)"
echo "   • Cloud tools (AWS, Azure, GCP CLIs)"
echo "   • Infrastructure as Code (Terraform, Ansible, Vault)"
echo "   • Database tools (PostgreSQL, Redis, MongoDB)"
echo "   • Performance testing (vegeta, jaggr, jplot)"
echo "   • Security tools (gnupg, mkcert, certbot)"
echo "   • Mobile development (Android Studio, CocoaPods, Flutter)"
echo "   • Data science tools (miniconda, jupyter, R, graphviz)"
echo "   • Network tools (nmap, mtr, ngrok)"
echo "   • Development apps (VS Code, iTerm2, Postman, etc.)"
echo "   • Productivity tools (Raycast, Rectangle, Obsidian, Grammarly)"
echo "   • Zsh enhancements (syntax highlighting, autosuggestions)"
echo ""
echo "🔧 Next Steps:"
echo "   1. Restart your terminal or run: source ~/.zshrc"
echo "   2. Set up version managers:"
echo "      • nvm install --lts    (Node.js)"
echo "      • pyenv install 3.12.0 (Python)"
echo "   3. Configure Git:"
echo "      • git config --global user.name 'Your Name'"
echo "      • git config --global user.email 'your@email.com'"
echo "   4. Set up cloud CLIs (aws configure, az login, gcloud init)"
echo "   5. Configure data science environment (see conda commands above)"
echo "   6. Set up local development certificates: mkcert -install"
echo ""
echo "📊 Summary:"
brew list --formula | wc -l | xargs echo "   • Formula packages installed:"
brew list --cask | wc -l | xargs echo "   • Cask applications installed:"
echo ""
echo "🚀 Happy coding!"