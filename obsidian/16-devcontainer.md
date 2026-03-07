# Devcontainer + OrbStack

Run Claude Code with full autonomous permissions inside a sandboxed devcontainer on macOS. Uses your claude.ai subscription (no API key), OrbStack as the container runtime, and a default-deny network firewall for security.

## Prerequisites

- macOS (Apple Silicon or Intel)
- Claude Pro or Max subscription
- VS Code with [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- Homebrew

## OrbStack

OrbStack replaces Docker Desktop — starts in ~2 seconds, idles at ~1.1 GB RAM (vs 3–4 GB).

```bash
brew install orbstack
```

Automatically provisions `docker` CLI, Docker Compose, and Rosetta emulation. No further config needed.

> Free for personal use. Commercial use (>$10K/year revenue) requires a subscription (~$8/mo).

## Host Authentication

The devcontainer has no browser, so OAuth login happens once on your host first. Credentials are mounted into the container automatically.

```bash
npm install -g @anthropic-ai/claude-code
claude                           # browser opens — select "Claude account with subscription"
/status                          # verify: "Login method: Claude Max Account"
/exit
```

> Do **not** set `ANTHROPIC_API_KEY` in your shell config. If present, Claude Code uses API billing instead of your subscription. Verify: `echo $ANTHROPIC_API_KEY` should be empty.

## File Structure

The devcontainer files live in your project's `.devcontainer/` directory:

```
your-project/
├── .devcontainer/
│   ├── devcontainer.json        # Container config, mounts, extensions
│   ├── Dockerfile               # node:20 + iptables + Claude Code
│   └── init-firewall.sh         # Default-deny egress firewall
└── .claude/
    └── settings.json            # Granular permissions (allow/deny)
```

Reference copies of these files are in `~/dotfiles/.devcontainer/`.

## Dockerfile

Uses `node:20` Debian — **never Alpine** (musl libc causes Claude Code crashes). Installs firewall tools, runs as non-root `node` user.

```dockerfile
FROM node:20

ARG CLAUDE_CODE_VERSION=latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    less git procps sudo fzf zsh man-db unzip gnupg2 gh \
    iptables ipset iproute2 dnsutils aggregate jq nano vim \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG USERNAME=node
RUN mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R $USERNAME /commandhistory

RUN mkdir -p /usr/local/share/npm-global \
  && chown -R node:node /usr/local/share

ENV DEVCONTAINER=true
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin
ENV SHELL=/bin/zsh

RUN mkdir -p /workspace /home/node/.claude \
  && chown -R node:node /workspace /home/node/.claude

WORKDIR /workspace
USER node
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}

COPY init-firewall.sh /usr/local/bin/
USER root
RUN chmod +x /usr/local/bin/init-firewall.sh \
  && echo "node ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" \
       > /etc/sudoers.d/node-firewall \
  && chmod 0440 /etc/sudoers.d/node-firewall
USER node
```

## devcontainer.json

Mounts host `~/.claude` for subscription credentials. No `ANTHROPIC_API_KEY` needed.

```jsonc
{
  "name": "Claude Code",
  "build": {
    "dockerfile": "Dockerfile",
    "args": { "CLAUDE_CODE_VERSION": "latest" }
  },
  "runArgs": [
    "--cap-drop=ALL",
    "--cap-add=NET_ADMIN",
    "--cap-add=NET_RAW",
    "--security-opt=no-new-privileges",
    "--pids-limit=512",
    "--memory=4g"
  ],
  "remoteUser": "node",
  "containerUser": "node",
  "mounts": [
    "source=${localEnv:HOME}/.claude,target=/home/node/.claude,type=bind,consistency=cached",
    "source=claude-code-history-${devcontainerId},target=/commandhistory,type=volume"
  ],
  "remoteEnv": {},
  "postStartCommand": "sudo /usr/local/bin/init-firewall.sh",
  "customizations": {
    "vscode": {
      "extensions": [
        "anthropic.claude-code",
        "dbaeumer.vscode-eslint",
        "esbenp.prettier-vscode",
        "eamodio.gitlens",
        "usernamehw.errorlens"
      ],
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh",
        "editor.formatOnSave": true
      }
    }
  }
}
```

> The `~/.claude` bind mount is read-write so Claude Code can refresh OAuth tokens. For full isolation, replace with a named volume and run `claude /login` inside the container once.

## Network Firewall

Default-deny egress — only whitelisted domains can be reached. This is the primary security layer that makes `--dangerously-skip-permissions` acceptable.

```bash
#!/bin/bash
set -euo pipefail

iptables -F OUTPUT 2>/dev/null || true
iptables -F INPUT  2>/dev/null || true
ipset destroy allowed-domains 2>/dev/null || true
ipset create allowed-domains hash:net

resolve_and_add() {
  local domain="$1"
  dig +short "$domain" | grep -E '^[0-9]+\.' | while read -r ip; do
    ipset add allowed-domains "$ip/32" 2>/dev/null || true
  done
}

# Anthropic API
resolve_and_add "api.anthropic.com"
resolve_and_add "statsig.anthropic.com"

# npm registry
resolve_and_add "registry.npmjs.org"
resolve_and_add "registry.yarnpkg.com"

# GitHub
resolve_and_add "github.com"
resolve_and_add "api.github.com"
resolve_and_add "objects.githubusercontent.com"
curl -sf https://api.github.com/meta 2>/dev/null \
  | jq -r '.git[], .web[], .api[]' 2>/dev/null \
  | while read -r cidr; do ipset add allowed-domains "$cidr" 2>/dev/null || true; done

# VS Code marketplace
resolve_and_add "marketplace.visualstudio.com"
resolve_and_add "vscode.blob.core.windows.net"

# Rules
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m set --match-set allowed-domains dst -j ACCEPT
iptables -A OUTPUT -j DROP

echo "[firewall] Initialized. Default-deny egress active."
```

> DNS (port 53) must remain open for domain resolution. If your threat model requires DNS exfiltration prevention, use an in-container resolver pointed at a controlled upstream.

## Granular Permissions

Place at `.claude/settings.json` in your project root. `deny` rules always override `allow`.

| Category | Examples |
|----------|----------|
| **Allowed** | `Read(**)`, `Write(**)`, `Edit(**)`, npm/yarn/pnpm, safe git ops, filesystem inspection, build/test tools |
| **Denied** | `git push`, `rm -rf`, `sudo`, pipe-to-shell (`curl \| bash`), SSH/SCP, Docker-in-Docker, crontab |

Any command not matched by `allow` prompts for confirmation in interactive mode or is blocked in headless mode. See the full settings.json in `~/dotfiles/.devcontainer/` or the reference guide.

## Running Claude Code

### Interactive (VS Code)

```bash
# ⌘⇧P → Dev Containers: Reopen in Container
# Then in the integrated terminal:
/status                          # verify subscription auth
claude --dangerously-skip-permissions "your task here"
```

### Headless / scripted

```bash
claude -p --dangerously-skip-permissions \
  --max-turns 10 \
  --max-budget-usd 3.00 \
  "Refactor the auth module to use JWT"

# JSON output for piping
claude -p --dangerously-skip-permissions \
  --output-format json \
  "Run tests and summarize failures" | jq '.result'
```

### Re-authenticate (if session expires)

```bash
claude /logout && claude /login
# Copy the printed URL to your host browser
```

## Neovim Integration

### Option A — VS Code Neovim extension

Add to `devcontainer.json`:

```jsonc
"extensions": ["asvetliakov.vscode-neovim"],
"settings": { "vscode-neovim.neovimExecutablePaths.linux": "/usr/bin/nvim" }
```

Add to Dockerfile: `RUN apt-get install -y --no-install-recommends neovim`

Mount config: `"source=${localEnv:HOME}/.config/nvim,target=/home/node/.config/nvim,type=bind,consistency=cached"`

### Option B — claudecode.nvim (native Neovim)

```lua
{
  "coder/claudecode.nvim",
  config = function()
    require("claudecode").setup({
      terminal = { split_side = "right", split_width_percentage = 0.38 },
    })
  end,
  keys = {
    { "<leader>cc", "<cmd>ClaudeCode<CR>", desc = "Toggle Claude Code" },
    { "<leader>cf", "<cmd>ClaudeCodeFocus<CR>", desc = "Focus Claude Code" },
  },
}
```

## CI/CD

### GitHub Actions — official action

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    claude_args: |
      --max-turns 5
      --allowedTools "Read,Edit,Write,Bash(npm test),Bash(npm run lint)"
```

> CI requires `ANTHROPIC_API_KEY` (subscription OAuth is browser-based). Store as a GitHub Actions secret — never committed.

### Reusing devcontainer in CI

```yaml
- uses: devcontainers/ci@v0.3
  env:
    ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
  with:
    imageName: ghcr.io/${{ github.repository }}/dev
    runCmd: |
      claude -p "Run tests and report failures" \
        --dangerously-skip-permissions --max-turns 5 --output-format json > results.json
```

## Security Posture

| Layer | Mechanism | Stops |
|-------|-----------|-------|
| Network | iptables default-deny | Exfiltration, malicious mirrors, C2 callbacks |
| Filesystem | Container boundary | Host SSH keys, browser cookies, Keychain |
| Process | Container boundary | Host processes, system daemons |
| Permissions | `.claude/settings.json` deny rules | Destructive git, privilege escalation, pipe-to-shell |

**Residual risks:**
- DNS tunneling (port 53 open for firewall itself)
- `~/.claude` bind mount allows container to modify host credentials
- Workspace `.env` and git credentials readable by Claude
- Anthropic API could relay workspace data as prompt content

## Quick Reference

```bash
brew install orbstack                              # install runtime
claude                                             # host auth (once)
# ⌘⇧P → Reopen in Container                      # open devcontainer
claude --dangerously-skip-permissions "task"        # autonomous mode
claude -p --dangerously-skip-permissions \
  --max-turns 10 --max-budget-usd 2.00 "task"      # headless with guardrails
claude /logout && claude /login                    # re-auth if expired
```

## Related

- [[02-claude-code|Claude Code]] — Agent workflow, aliases, project setup
- [[04-docker|Docker]] — Colima, Docker Compose, cleanup
- [[14-claude-pkm|Claude PKM]] — Persistent knowledge with agents
