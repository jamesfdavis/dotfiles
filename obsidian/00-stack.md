# The Stack

The entire development environment fits in one idea: **the agent writes the code, you steer**.

## Tools

| Layer | Tool | Why |
|-------|------|-----|
| Terminal | [[01-ghostty-starship\|Ghostty + Starship]] | Fast GPU rendering, minimal prompt |
| Agent | [[02-claude-code\|Claude Code]] | Reads the codebase, writes the code, runs the tests |
| Platform | [[03-cloudflare\|Cloudflare Workers]] | Edge compute, D1, KV, R2 -- zero servers to manage |
| Deploy | Wrangler | `wrp` and it's live |
| Data | [[04-docker\|Colima + Docker]] | Local Postgres, Redis, or anything via containers |
| Git | [[05-git-workflow\|lazygit + gh]] | Visual staging, PR creation without leaving the terminal |
| Editor | Neovim | Quick manual edits when the agent isn't needed |
| Review | VS Code | Code review and visual diffs |

## Install

```bash
git clone https://github.com/jamesfdavis/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

Everything is automated: Homebrew packages, config symlinks, SSH keys, npm globals.

## Principles

1. **Agent-first** -- Claude Code is the primary interface for writing and modifying code.
2. **Terminal-native** -- Everything runs in Ghostty. No context switching to a GUI editor.
3. **Cloudflare-native** -- Workers, D1, KV, R2, Pages. No AWS/GCP complexity.
4. **Minimal tooling** -- If a tool doesn't serve the Cloudflare + agent workflow, it's not installed.
