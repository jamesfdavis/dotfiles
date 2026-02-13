# Ghostty + Starship

## Ghostty

GPU-accelerated terminal. Config lives at `~/.config/ghostty/config` (symlinked from dotfiles).

Key settings:
- FiraCode Nerd Font at 14pt (thickened for Retina)
- Catppuccin Mocha color scheme
- Hidden macOS title bar for more screen space
- 50k scrollback
- No close confirmation (power user)

### Keybindings

| Shortcut | Action |
|----------|--------|
| Cmd+D | Split right |
| Cmd+Shift+D | Split down |
| Cmd+Alt+Arrows | Navigate splits |
| Cmd+Ctrl+Arrows | Resize splits |
| Cmd+Shift+Enter | Zoom split (toggle) |
| Cmd+Shift+E | Equalize splits |
| Cmd+1-5 | Jump to tab |
| Cmd+Shift+, | Reload config |

## Starship

Cross-shell prompt. Config at `~/.config/starship.toml`.

Shows only what matters:
- Current directory (2 levels)
- Git branch + dirty/clean status
- Node version (only in projects with package.json)
- Python virtualenv name (only when active)
- Docker context (only when active)
- Command duration (only for slow commands >3s)

Everything else is disabled to keep the prompt fast.

## Why not Oh My Zsh?

Oh My Zsh loads hundreds of completions and aliases on every shell startup. We only need four plugins:
- `zsh-autosuggestions` -- fish-like inline suggestions
- `zsh-syntax-highlighting` -- colors commands as you type
- `zsh-history-substring-search` -- type + Up arrow to cycle matching history
- `sudo` widget -- double-tap Esc to prepend sudo

All installed via Homebrew (or inline in `.zshrc`) and sourced directly. Shell startup is instant. See [[13-zsh-shell]] for full details.

## Key aliases

```bash
reload  # restart shell
cls     # clear
lt      # tree view via eza
z foo   # jump to directory (zoxide)
```
