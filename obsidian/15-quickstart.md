# Quickstart

Get from zero to working dev environment in one command.

## Install

```bash
git clone https://github.com/jamesfdavis/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

Five steps run automatically:

1. **Homebrew** -- installs all packages from `Brewfile`
2. **Symlinks** -- dotfiles and `~/.config` directories
3. **SSH keys** -- generates auth + signing key pair, configures macOS Keychain persistence
4. **Node.js** -- installs LTS via NVM
5. **npm globals** -- installs `claude-code` and `wrangler`

## Post-install checklist

1. Restart your terminal (or `source ~/.zshrc`)
2. Register both SSH keys on GitHub -- the install script prints them
   - `~/.ssh/id_ed25519.pub` -> **Authentication** key
   - `~/.ssh/id_ed25519_signing.pub` -> **Signing** key
3. Set up secrets: `cp ~/.extra.example ~/.extra && nvim ~/.extra`
4. Auth GitHub CLI: `gh auth login`
5. Start Colima: `colima start`

## What you get

| What | Tool | Key alias | Reference |
|------|------|-----------|-----------|
| Terminal | Ghostty (Catppuccin Mocha) | -- | [[01-ghostty-starship]] |
| Shell | Zsh + Starship prompt | -- | [[13-zsh-shell]] |
| AI agent | Claude Code | `cc` | [[02-claude-code]] |
| Editor | Neovim (Telescope, Treesitter) | `v` | [[07-neovim]] |
| Git UI | Lazygit | `lg` | [[11-lazygit]] |
| Git | SSH-signed commits, rebase-by-default | `gs` `ga` `gcm` `gp` | [[05-git-workflow]] |
| Search | ripgrep + fd + fzf | `rg` `fd` `Ctrl+T` | [[08-fzf-ripgrep-fd]] |
| Node | NVM with auto .nvmrc switching | lazy-loaded | [[10-node-nvm]] |
| Python | uv | `uvv` `uva` | [[06-python-uv]] |
| Cloudflare | Wrangler | `wr` `wrd` `wrp` | [[03-cloudflare]] |
| Smart cd | zoxide | `z <dir>` | [[09-cli-utilities]] |
| Docker | Colima + Docker Compose | `dc` `dcu` `dcd` | [[04-docker]] |
| GitHub | gh CLI | `ghpr` `ghprw` | [[12-github-cli]] |

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

## Workflow

Features follow: **Scaffold -> Plan -> Issues -> Build -> Verify**

See [[02-claude-code|Claude Code]] for the full workflow breakdown, or [[README|Dev Home]] for the quick reference.

Follow the workflow phases:

- **Scaffold** -- generate a new SvelteKit PWA + Cloudflare project
- **Plan** -- research codebase, draft stack-aware design, get approval
- **Issues** -- break plan into sized GitHub issues with dependency links
- **Build** -- layered TDD: unit -> component -> E2E, then commit
- **Verify** -- browser-based UI verification via `claude --chrome`

Skip steps when appropriate: existing project? skip Scaffold. Small fix? skip to Build. No UI? skip Verify.

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

See [[05-git-workflow|Git Workflow]] for the full list and branching strategy.

## Updating

```bash
cd ~/dotfiles && git pull    # symlinks update instantly
brewup                       # update Homebrew packages
```
