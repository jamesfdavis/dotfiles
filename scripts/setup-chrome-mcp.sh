#!/bin/bash
# ------------------------------------------------------------------------------
# setup-chrome-mcp.sh - Register Chrome DevTools MCP server with Claude Code
#
# Provides 26 tools across performance tracing, network inspection, debugging,
# input automation, navigation, and emulation via Chrome DevTools Protocol.
#
# Key flags for Claude Code dev sessions:
#   --headless=true        Terminal-native; no visible browser needed for profiling
#   --isolated=true        Temporary profile; no interference with normal Chrome
#   --no-usage-statistics  Opt out of anonymous telemetry
#   --viewport=1280x720    Consistent viewport for screenshots/snapshots
#
# Requires: claude (npm @anthropic-ai/claude-code), Node.js 20.19+, Chrome
# Repo: https://github.com/ChromeDevTools/chrome-devtools-mcp
# Docs: https://developer.chrome.com/blog/chrome-devtools-mcp
# ------------------------------------------------------------------------------
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Verify prerequisites
if ! command -v claude &>/dev/null; then
    echo -e "  ${RED}claude not found -- install claude-code first${NC}"
    exit 1
fi

if ! command -v npx &>/dev/null; then
    echo -e "  ${RED}npx not found -- install Node.js first${NC}"
    exit 1
fi

# Check if Chrome DevTools MCP is already registered
if claude mcp list 2>/dev/null | grep -q "chrome-devtools"; then
    echo -e "  ${GREEN}Chrome DevTools MCP already registered${NC}"
    exit 0
fi

# Register Chrome DevTools MCP server with Claude Code
# Flags tuned for terminal-native Claude Code sessions:
#   --headless       no GUI needed for perf/network/debug tools
#   --isolated       temp profile avoids leaking browsing state
#   --no-usage-stats opt out of telemetry
#   --viewport       stable size for consistent screenshots
echo "  Registering Chrome DevTools MCP server..."
if claude mcp add chrome-devtools -- \
    npx chrome-devtools-mcp@latest \
    --headless=true \
    --isolated=true \
    --no-usage-statistics \
    --viewport=1280x720 2>/dev/null; then
    echo -e "  ${GREEN}Chrome DevTools MCP registered${NC}"
else
    echo -e "  ${YELLOW}Chrome DevTools MCP registration failed${NC}"
    echo -e "  ${YELLOW}Retry: claude mcp add chrome-devtools -- npx chrome-devtools-mcp@latest --headless=true --isolated=true --no-usage-statistics --viewport=1280x720${NC}"
    exit 1
fi

# Verify registration
if claude mcp list 2>/dev/null | grep -q "chrome-devtools"; then
    echo -e "  ${GREEN}Verified: chrome-devtools MCP server active${NC}"
else
    echo -e "  ${YELLOW}Registration may need a Claude Code restart to take effect${NC}"
fi
