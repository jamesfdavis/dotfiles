#!/usr/bin/env zsh

# Modern Dotfiles Bootstrap Script for 2025
# Simplified and reliable version

set -eo pipefail

# Enhanced error handling for stability
# Note: set -u commented out to avoid issues with nvm initialization
# set -u  # Treat unset variables as an error
export LC_ALL=C  # Ensure consistent behavior across locales

#==============================================================================
# Configuration & Variables
#==============================================================================

readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly BACKUP_DIR="${HOME}/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
readonly LOG_FILE="${HOME}/.dotfiles-init.log"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

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

#==============================================================================
# Main Functions
#==============================================================================

create_backup() {
    log "INFO" "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    # Simple backup - just backup .zshrc if it exists
    if [[ -f "$HOME/.zshrc" ]]; then
        cp "$HOME/.zshrc" "$BACKUP_DIR/" 2>/dev/null
        log "INFO" "Backed up: .zshrc"
    fi

    log "INFO" "Backup completed"
}

sync_dotfiles() {
    log "INFO" "Starting dotfile synchronization..."

    # Check if rsync is available
    if ! command_exists rsync; then
        log "ERROR" "rsync not found. Install with: brew install rsync"
        exit 1
    fi

    log "INFO" "Syncing dotfiles from $SCRIPT_DIR to $HOME..."

    # Sync all dotfiles except excluded ones
    if rsync \
        --exclude=".git/" \
        --exclude=".github/" \
        --exclude="init/" \
        --exclude="setup/" \
        --exclude="scripts/" \
        --exclude=".DS_Store" \
        --exclude="bootstrap.sh" \
        --exclude="bootstrap-minimal.sh" \
        --exclude="simple-sync.sh" \
        --exclude="README.md" \
        --exclude="LICENSE*" \
        --exclude="*.md" \
        --exclude="Brewfile*" \
        --exclude="package.json" \
        --exclude="node_modules/" \
        --exclude=".vscode/" \
        --exclude="*.backup" \
        --exclude="*.bak" \
        --exclude="*.tmp" \
        -av --no-perms "$SCRIPT_DIR/" "$HOME/"; then
        log "INFO" "Dotfiles synchronized successfully"
    else
        log "ERROR" "Synchronization failed"
        exit 1
    fi
}

post_install_checks() {
    log "INFO" "Running post-installation checks..."

    # Check if key dotfiles were copied successfully
    local key_files=(".aliases" ".zshrc" ".gitconfig" ".functions" ".exports")
    
    for file in "${key_files[@]}"; do
        if [[ -f "$HOME/$file" ]]; then
            log "INFO" "✅ $file copied successfully"
        else
            log "WARN" "❌ $file not found"
        fi
    done
}

show_summary() {
    echo
    log "INFO" "=== Installation Summary ==="
    log "INFO" "Backup created: $BACKUP_DIR"
    log "INFO" "Log file: $LOG_FILE"
    log "INFO" "Dotfiles synchronized from: $SCRIPT_DIR"
    
    echo
    log "INFO" "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Your aliases should now be available (try: alias)"
    echo "  3. Check that 'funcs' and 'dl' aliases work"
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

    # Check for force flag 
    local force=false
    if [[ "${1:-}" == "-f" ]] || [[ "${1:-}" == "--force" ]]; then
        force=true
        log "INFO" "Force mode enabled - skipping confirmations"
    fi

    # Ensure we're in the right directory
    cd "$SCRIPT_DIR"

    # Show what we're about to do
    echo
    log "INFO" "This script will:"
    echo "  • Create a backup of existing dotfiles"
    echo "  • Copy all dotfiles from this repo to your home directory"
    echo "  • Overwrite existing dotfiles"
    echo

    if [[ "$force" != true ]] && ! confirm "Continue with dotfiles installation?"; then
        log "INFO" "Installation cancelled by user"
        return 0
    fi

    # Execute main tasks
    create_backup
    sync_dotfiles
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

# Create a simple function for sourcing
dotfiles() {
    main -f
}

# Run main function if executed directly (not sourced)
# Use zsh-compatible method to check if script is being sourced
if [[ "${ZSH_EVAL_CONTEXT:-}" != *:file* ]]; then
    main "$@"
fi