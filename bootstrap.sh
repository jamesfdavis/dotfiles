#!/usr/bin/env zsh

# Modern Dotfiles Init Script for 2025
# Enhanced with safety, logging, and better practices

set -euo pipefail  # Exit on error, undefined vars, pipe failures

#==============================================================================
# Configuration & Variables
#==============================================================================

readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly DOTFILES_DIR="$SCRIPT_DIR"
readonly BACKUP_DIR="${HOME}/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
readonly LOG_FILE="${HOME}/.dotfiles-init.log"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Files and directories to exclude from sync
readonly EXCLUDE_PATTERNS=(
    ".git/"
    ".github/"
    "init/"
    "setup/"
    "scripts/"
    ".DS_Store"
    "bootstrap.sh"
    "README.md"
    "LICENSE*"
    "*.md"
    "Brewfile*"
    "package.json"
    "node_modules/"
    ".vscode/"
    "*.backup"
    "*.bak"
    "*.tmp"
)

#==============================================================================
# Utility Functions
#==============================================================================

# Logging function
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    case "$level" in
        "INFO")  echo -e "${GREEN}[INFO]${NC} $message" ;;
        "WARN")  echo -e "${YELLOW}[WARN]${NC} $message" ;;
        "ERROR") echo -e "${RED}[ERROR]${NC} $message" ;;
        "DEBUG") echo -e "${BLUE}[DEBUG]${NC} $message" ;;
    esac

    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Confirm action with user
confirm() {
    local prompt="$1"
    local response

    while true; do
        echo -n "$prompt (y/n): "
        read -r response
        case "$response" in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo "Please answer yes or no." ;;
        esac
    done
}

# Create backup of existing dotfiles
create_backup() {
    log "INFO" "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    local files_to_backup=(
        ".zshrc"
        ".vimrc"
        ".tmux.conf"
        ".gitconfig"
        ".gitignore_global"
        ".aliases"
        ".functions"
        ".exports"
        ".inputrc"
        ".wgetrc"
        ".screenrc"
        ".gvimrc"
    )

    local backup_count=0
    for file in "${files_to_backup[@]}"; do
        if [[ -f "$HOME/$file" ]]; then
            cp "$HOME/$file" "$BACKUP_DIR/" 2>/dev/null && {
                log "INFO" "Backed up: $file"
                ((backup_count++))
            }
        fi
    done

    log "INFO" "Backed up $backup_count files to $BACKUP_DIR"
    return 0
}

#==============================================================================
# Git Operations
#==============================================================================

update_repository() {
    log "INFO" "Updating dotfiles repository..."

    if [[ ! -d "$DOTFILES_DIR" ]]; then
        log "ERROR" "Dotfiles directory not found: $DOTFILES_DIR"
        log "INFO" "Clone with: git clone <your-repo-url> $DOTFILES_DIR"
        exit 1
    fi

    cd "$DOTFILES_DIR" || {
        log "ERROR" "Failed to change to dotfiles directory"
        exit 1
    }

    # Check if we're in a git repository
    if [[ ! -d ".git" ]]; then
        log "ERROR" "Not a git repository: $DOTFILES_DIR"
        exit 1
    fi

    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        log "WARN" "Uncommitted changes detected in dotfiles repository"
        if confirm "Continue anyway?"; then
            log "INFO" "Proceeding with uncommitted changes..."
        else
            log "INFO" "Aborted by user"
            exit 1
        fi
    fi

    # Fetch and merge
    local current_branch=$(git branch --show-current)
    log "INFO" "Current branch: $current_branch"

    if ! git fetch origin; then
        log "ERROR" "Failed to fetch from origin"
        exit 1
    fi

    # Use current branch instead of hardcoded 'master'
    if ! git pull origin "$current_branch"; then
        log "ERROR" "Failed to pull from origin/$current_branch"
        exit 1
    fi

    log "INFO" "Repository updated successfully"
}

#==============================================================================
# Dotfile Synchronization
#==============================================================================

sync_dotfiles() {
    log "INFO" "Starting dotfile synchronization..."

    # Build rsync exclude arguments
    local exclude_args=()
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        exclude_args+=(--exclude="$pattern")
    done

    # Check if rsync is available
    if ! command_exists rsync; then
        log "ERROR" "rsync not found. Install with: brew install rsync"
        exit 1
    fi

    # Perform dry run first
    log "INFO" "Performing dry run..."
    if ! rsync "${exclude_args[@]}" --dry-run -avh --no-perms "$DOTFILES_DIR/" "$HOME/"; then
        log "ERROR" "Dry run failed"
        exit 1
    fi

    # Show what would be copied
    echo
    log "INFO" "Files that will be synchronized:"
    rsync "${exclude_args[@]}" --dry-run -avh --no-perms "$DOTFILES_DIR/" "$HOME/" | grep -E '^[^d]' | head -20
    echo

    if confirm "Proceed with synchronization?"; then
        # Actual sync
        if rsync "${exclude_args[@]}" -avh --no-perms "$DOTFILES_DIR/" "$HOME/"; then
            log "INFO" "Dotfiles synchronized successfully"
        else
            log "ERROR" "Synchronization failed"
            exit 1
        fi
    else
        log "INFO" "Synchronization cancelled by user"
        exit 0
    fi
}

#==============================================================================
# Post-Installation Tasks
#==============================================================================

reload_shell() {
    log "INFO" "Reloading shell configuration..."

    # Source the new configuration files
    local config_files=(
        "$HOME/.zshrc"
        "$HOME/.exports"
        "$HOME/.aliases"
        "$HOME/.functions"
    )

    for config_file in "${config_files[@]}"; do
        if [[ -f "$config_file" ]]; then
            if source "$config_file" 2>/dev/null; then
                log "INFO" "Sourced: $(basename "$config_file")"
            else
                log "WARN" "Failed to source: $(basename "$config_file")"
            fi
        fi
    done
}

post_install_checks() {
    log "INFO" "Running post-installation checks..."

    # Check if Oh My Zsh is installed
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log "WARN" "Oh My Zsh not found. Install with:"
        echo 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
    fi

    # Check for required tools
    local required_tools=(
        "git"
        "brew"
        "fzf"
        "bat"
        "eza"
    )

    local missing_tools=()
    for tool in "${required_tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_tools+=("$tool")
        fi
    done

    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        log "WARN" "Missing recommended tools: ${missing_tools[*]}"
        log "INFO" "Install with: brew install ${missing_tools[*]}"
    fi

    # Check Git configuration
    if ! git config --global user.name >/dev/null 2>&1; then
        log "WARN" "Git user.name not set. Configure with: git config --global user.name 'Your Name'"
    fi

    if ! git config --global user.email >/dev/null 2>&1; then
        log "WARN" "Git user.email not set. Configure with: git config --global user.email 'your@email.com'"
    fi
}

show_summary() {
    echo
    log "INFO" "=== Installation Summary ==="
    log "INFO" "Backup created: $BACKUP_DIR"
    log "INFO" "Log file: $LOG_FILE"
    log "INFO" "Dotfiles synchronized from: $DOTFILES_DIR"

    if [[ -s "$LOG_FILE" ]]; then
        local warnings=$(grep -c "\[WARN\]" "$LOG_FILE" 2>/dev/null || echo "0")
        local errors=$(grep -c "\[ERROR\]" "$LOG_FILE" 2>/dev/null || echo "0")

        log "INFO" "Warnings: $warnings, Errors: $errors"
    fi

    echo
    log "INFO" "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Install missing tools if any were reported"
    echo "  3. Configure Git if not already done"
    echo "  4. Install Oh My Zsh plugins if needed"
    echo
}

#==============================================================================
# Main Execution
#==============================================================================

main() {
    log "INFO" "Starting modern dotfiles initialization..."
    log "INFO" "Script: $0"
    log "INFO" "User: $USER"
    log "INFO" "Home: $HOME"
    log "INFO" "Date: $(date)"

    # Ensure we're in the right directory
    cd "$DOTFILES_DIR"

    # Pre-flight checks
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        log "ERROR" "Dotfiles directory not found: $DOTFILES_DIR"
        exit 1
    fi

    # Show what we're about to do
    echo
    log "INFO" "This script will:"
    echo "  • Update the dotfiles repository"
    echo "  • Create a backup of existing dotfiles"
    echo "  • Synchronize new dotfiles to your home directory"
    echo "  • Reload shell configuration"
    echo "  • Run post-installation checks"
    echo

    if ! confirm "Continue with dotfiles installation?"; then
        log "INFO" "Installation cancelled by user"
        exit 0
    fi

    # Execute main tasks
    create_backup
    update_repository
    sync_dotfiles
    reload_shell
    post_install_checks
    show_summary

    log "INFO" "Dotfiles initialization completed successfully!"
}

#==============================================================================
# Error Handling
#==============================================================================

cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log "ERROR" "Script failed with exit code $exit_code"
        log "INFO" "Check the log file for details: $LOG_FILE"

        if [[ -d "$BACKUP_DIR" ]]; then
            log "INFO" "Your original files are backed up in: $BACKUP_DIR"
        fi
    fi
}

trap cleanup EXIT

#==============================================================================
# Script Entry Point
#==============================================================================

# Check if running with zsh
if [[ -z "${ZSH_VERSION:-}" ]]; then
    log "WARN" "This script is designed for zsh but running with: $0"
fi

# Run main function
main "$@"
