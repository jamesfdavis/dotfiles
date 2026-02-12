# dotfiles

> Agent-first Cloudflare development on macOS.
> **Stack:** Ghostty + Starship + Claude Code + Wrangler + Colima/Docker + lazygit

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE-MIT.txt)

## Install

```bash
git clone https://github.com/jamesfdavis/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

Four steps run automatically:
1. **Homebrew** -- installs all packages from `Brewfile`
2. **Symlinks** -- dotfiles and `~/.config` directories
3. **SSH keys** -- generates auth + signing key pair
4. **npm globals** -- installs `claude-code` and `wrangler`

## What gets installed

| Category | Packages |
|----------|----------|
| **Terminal** | Ghostty, Starship, zsh-autosuggestions, zsh-syntax-highlighting, Fira Code Nerd Font |
| **Agent** | Claude Code (npm global) |
| **Platform** | Wrangler (npm global) |
| **Git** | git, gh, lazygit |
| **Containers** | Colima, Docker, Docker Compose |
| **CLI** | ripgrep, fd, fzf, jq, bat, eza |
| **Editors** | Neovim (terminal), VS Code (review) |

## File structure

```
dotfiles/
├── install.sh              # Main entry point
├── bootstrap.sh            # Symlinks everything
├── Brewfile                # Homebrew packages
│
├── config/
│   ├── ghostty/config      # Terminal config  -> ~/.config/ghostty/
│   ├── starship.toml       # Prompt config    -> ~/.config/starship.toml
│   └── nvim/init.lua       # Neovim config    -> ~/.config/nvim/
│
├── scripts/
│   ├── setup-homebrew.sh   # Brew + bundle
│   └── setup-ssh-signing.sh# SSH key generation
│
├── obsidian/               # Developer workflow docs
│   ├── 00-stack.md         # Tool stack overview
│   ├── 01-ghostty-starship.md
│   ├── 02-claude-code.md
│   ├── 03-cloudflare.md
│   ├── 04-docker.md
│   └── 05-git-workflow.md
│
├── docs/
│   └── KEYS.md             # SSH key docs
│
├── .zshrc                  # Shell config (Starship, no Oh My Zsh)
├── .aliases                # All shell aliases
├── .exports                # Environment variables
├── .functions              # Shell functions
├── .gitconfig              # Git settings + SSH signing
├── .gitignore              # Global ignores
└── .extra.example          # Template for secrets
```

## Key aliases

```bash
# Claude Code
cc / ccc / ccr / cci        # claude / chat / resume / init

# Cloudflare
wr / wrd / wrp / wrl        # wrangler / dev / deploy / tail
wrd1 / wrkv / wrr2          # d1 / kv / r2

# Git
lg                          # lazygit
gs / ga / gcm / gp / gl     # status / add / commit / push / pull
glog / uncommit             # log graph / undo last commit

# GitHub
ghpr / ghprw / ghprc        # pr create / view web / checkout

# Docker
dc / dcu / dcd / dcl        # compose / up / down / logs

# Editors
v / c / c.                  # nvim / code / code .
```

## Post-install checklist

- [ ] Restart terminal (or `source ~/.zshrc`)
- [ ] Register SSH keys on GitHub: `cat ~/.ssh/id_ed25519.pub` and `cat ~/.ssh/id_ed25519_signing.pub`
- [ ] Set up secrets: `cp ~/.extra.example ~/.extra && nvim ~/.extra`
- [ ] Start Colima: `colima start`
- [ ] Auth GitHub CLI: `gh auth login`

## SSH signing

Two-key architecture for security isolation:

- **Auth key** (`~/.ssh/id_ed25519`) -- push/pull access
- **Signing key** (`~/.ssh/id_ed25519_signing`) -- commit verification

All commits signed automatically. See [docs/KEYS.md](docs/KEYS.md).

## Obsidian docs

The `obsidian/` folder contains developer workflow notes. Open it as a vault in Obsidian or read the markdown directly. Covers the full stack, Claude Code patterns, Cloudflare development, and git workflow.

## Maintenance

```bash
brewup                      # update all homebrew packages
cd ~/dotfiles && git pull   # pull dotfile changes (symlinks update instantly)
```

## License

[MIT](LICENSE-MIT.txt)
