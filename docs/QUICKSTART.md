# Dev Quickstart

## Install (one command)

```bash
git clone https://github.com/jamesfdavis/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

This runs five automated steps: Homebrew packages, config symlinks, SSH key generation, Node.js via NVM, and global npm installs (Claude Code + Wrangler).

## Post-install checklist

1. Restart your terminal (or `source ~/.zshrc`)
2. Register both SSH keys on GitHub — the install script prints them
   - `~/.ssh/id_ed25519.pub` → **Authentication** key
   - `~/.ssh/id_ed25519_signing.pub` → **Signing** key
3. Set up secrets: `cp ~/.extra.example ~/.extra && nvim ~/.extra`
4. Auth GitHub CLI: `gh auth login`

## What you get

| What | Tool | Key alias |
|------|------|-----------|
| Terminal | Ghostty (Catppuccin Mocha) | — |
| Shell | Zsh + Starship prompt | — |
| AI agent | Claude Code | `cc` |
| Editor | Neovim (Telescope, Treesitter) | `v` |
| Git UI | Lazygit | `lg` |
| Git | SSH-signed commits, rebase-by-default | `gs` `ga` `gcm` `gp` |
| Search | ripgrep + fd + fzf | `rg` `fd` `Ctrl+T` |
| Node | NVM with auto .nvmrc switching | lazy-loaded |
| Python | uv | `uvv` `uva` |
| Cloudflare | Wrangler | `wr` `wrd` `wrp` |
| Smart cd | zoxide | `z <dir>` |
| Docker | Colima + Docker Compose | `dc` `dcu` `dcd` |

## Workflow

Agent writes code, you steer. Everything runs in the terminal.

Features follow: **Scaffold → Plan → Issues → Build → Verify**

In Claude Code, use the slash commands:

- `/scaffold` — generate a new SvelteKit PWA + Cloudflare project
- `/plan` — research codebase, draft stack-aware design, get approval
- `/issues` — break plan into sized GitHub issues with dependency links
- `/build` — layered TDD: unit → component → E2E, then commit
- `/verify` — browser-based UI verification via `claude --chrome`

Skip steps when appropriate: existing project? skip `/scaffold`. Small fix? skip to `/build`. No UI? skip `/verify`.

## Day-one commands

```bash
dot           # jump to ~/dotfiles
cc            # launch Claude Code
lg            # open lazygit
v .           # open current dir in neovim
z <dir>       # smart directory jump
tre           # pretty tree view (3 levels)
brewup        # update all Homebrew packages
cleanup       # remove node_modules, dist, .wrangler, .DS_Store
genpass       # generate a secure random password
myip          # show external IP
serve         # quick Python HTTP server on port 8000
```

## Git aliases

```bash
gs            # git status
ga            # git add
gcm "msg"     # git commit -m
gp            # git push
gl            # git pull
glog          # git log --graph
uncommit      # undo last commit (soft reset)
```

## Docs

Detailed documentation for every tool lives in `~/dotfiles/obsidian/` (14 markdown files). Open it as an Obsidian vault or read them directly.

| File | Covers |
|------|--------|
| 00-stack.md | Full stack overview |
| 01-ghostty-starship.md | Terminal + prompt |
| 02-claude-code.md | Agent workflow |
| 03-cloudflare.md | Workers, D1, KV, R2 |
| 05-git-workflow.md | Git config + signing |
| 07-neovim.md | Editor keybindings |
| 08-fzf-ripgrep-fd.md | Search tools |
| 13-zsh-shell.md | Shell plugins + history |

## Updating

```bash
cd ~/dotfiles && git pull    # symlinks update instantly
brewup                       # update Homebrew packages
```
