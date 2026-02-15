#!/bin/bash
# ------------------------------------------------------------------------------
# setup-cloudflare-mcp.sh - Register Cloudflare Docs MCP server with Claude Code
#
# Provides semantic search across all Cloudflare developer documentation
# (Workers, Pages, D1, KV, R2, Agents, etc.) via the official MCP endpoint.
#
# Requires: claude (npm @anthropic-ai/claude-code), Node.js 18+
# Docs: https://developers.cloudflare.com/workers/get-started/prompting/
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

# Check if Cloudflare Docs MCP is already registered
if claude mcp list 2>/dev/null | grep -q "cloudflare-docs"; then
    echo -e "  ${GREEN}Cloudflare Docs MCP already registered${NC}"
    exit 0
fi

# Register Cloudflare Docs MCP server with Claude Code
echo "  Registering Cloudflare Docs MCP server..."
if claude mcp add cloudflare-docs -- npx mcp-remote@latest https://docs.mcp.cloudflare.com/sse 2>/dev/null; then
    echo -e "  ${GREEN}Cloudflare Docs MCP registered${NC}"
else
    echo -e "  ${YELLOW}Cloudflare Docs MCP registration failed (can retry: claude mcp add cloudflare-docs -- npx mcp-remote@latest https://docs.mcp.cloudflare.com/sse)${NC}"
    exit 1
fi

# Verify registration
if claude mcp list 2>/dev/null | grep -q "cloudflare-docs"; then
    echo -e "  ${GREEN}Verified: cloudflare-docs MCP server active${NC}"
else
    echo -e "  ${YELLOW}Registration may need a Claude Code restart to take effect${NC}"
fi
