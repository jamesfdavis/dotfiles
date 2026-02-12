# Ghostty + Starship

## Ghostty

GPU-accelerated terminal. Config lives at `~/.config/ghostty/config` (symlinked from dotfiles).

Key settings:
- FiraCode Nerd Font at 14pt
- Catppuccin Mocha color scheme
- Hidden macOS title bar for more screen space
- 50k scrollback

## Starship

Cross-shell prompt. Config at `~/.config/starship.toml`.

Shows only what matters:
- Current directory (2 levels)
- Git branch + dirty/clean status
- Node version (only in projects with package.json)
- Docker context (only when active)
- Command duration (only for slow commands >3s)

Everything else is disabled to keep the prompt fast.

## Why not Oh My Zsh?

Oh My Zsh loads hundreds of completions and aliases on every shell startup. We only need two plugins:
- `zsh-autosuggestions` -- fish-like inline suggestions
- `zsh-syntax-highlighting` -- colors commands as you type

Both installed via Homebrew and sourced directly in `.zshrc`. Shell startup is instant.

## Key aliases

```bash
reload  # restart shell
cls     # clear
lt      # tree view via eza
```
