#!/bin/bash
set -euo pipefail

# Flush existing rules
iptables -F OUTPUT 2>/dev/null || true
iptables -F INPUT  2>/dev/null || true
ipset destroy allowed-domains 2>/dev/null || true

# Create IP set for allowed destinations
ipset create allowed-domains hash:net

# ── Allowed outbound domains ─────────────────────────────────────────────────

resolve_and_add() {
  local domain="$1"
  dig +short "$domain" | grep -E '^[0-9]+\.' | while read -r ip; do
    ipset add allowed-domains "$ip/32" 2>/dev/null || true
  done
}

# Anthropic API — Claude Code's only required endpoint
resolve_and_add "api.anthropic.com"
resolve_and_add "statsig.anthropic.com"

# npm registry — for package installs inside the container
resolve_and_add "registry.npmjs.org"
resolve_and_add "registry.yarnpkg.com"

# GitHub — for git operations
resolve_and_add "github.com"
resolve_and_add "api.github.com"
resolve_and_add "objects.githubusercontent.com"

# GitHub's dynamic IP ranges (fetched once at startup)
curl -sf https://api.github.com/meta 2>/dev/null \
  | jq -r '.git[], .web[], .api[]' 2>/dev/null \
  | while read -r cidr; do
      ipset add allowed-domains "$cidr" 2>/dev/null || true
    done

# VS Code extension marketplace
resolve_and_add "marketplace.visualstudio.com"
resolve_and_add "vscode.blob.core.windows.net"

# ── iptables rules ────────────────────────────────────────────────────────────

# Allow loopback
iptables -A OUTPUT -o lo -j ACCEPT

# Allow DNS (required for domain resolution and runtime lookups)
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

# Allow established/related connections (responses to allowed outbound)
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow traffic to whitelisted IPs only
iptables -A OUTPUT -m set --match-set allowed-domains dst -j ACCEPT

# Default deny — block everything else
iptables -A OUTPUT -j DROP

echo "[firewall] Initialized. Default-deny egress active."
