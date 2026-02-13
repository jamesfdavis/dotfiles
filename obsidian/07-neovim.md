# Neovim

Neovim is the terminal editor for quick edits and git commit authoring. Claude Code is the primary development tool -- Neovim fills the gap for direct file editing, config tweaks, and commit messages.

## Opening files

```bash
v                   # nvim (alias)
v ~/.zshrc          # open a specific file
v .                 # open current directory (uses telescope to find files)
```

## Survival guide

Neovim has modes. You're always in one of these:

| Mode | How to enter | What it does |
|------|-------------|--------------|
| **Normal** | `Esc` | Navigate, delete, copy, paste |
| **Insert** | `i`, `a`, `o` | Type text |
| **Visual** | `v`, `V`, `Ctrl+v` | Select text |
| **Command** | `:` | Run commands |

The golden rule: **press `Esc` when confused**. It always returns to Normal mode.

## Leader key

The leader key is **Space**. All custom shortcuts start with it.

| Shortcut | Action |
|----------|--------|
| `Space w` | Save file |
| `Space q` | Quit |
| `Space f` | Find files (telescope) |
| `Space g` | Live grep across project (telescope) |
| `Space b` | Switch between open buffers |
| `Space /` | Fuzzy search current file |
| `Space ss` | Strip trailing whitespace |

## Essential motions

### Moving around

| Key | Movement |
|-----|----------|
| `h j k l` | Left, down, up, right (arrow keys also work) |
| `w` / `b` | Forward / back one word |
| `0` / `$` | Start / end of line |
| `gg` / `G` | Top / bottom of file |
| `Ctrl+d` / `Ctrl+u` | Half-page down / up (auto-centers) |
| `{` / `}` | Previous / next paragraph |
| `5j` / `5k` | Jump 5 lines down / up (relative numbers help here) |

### Editing

| Key | Action |
|-----|--------|
| `i` | Insert before cursor |
| `a` | Insert after cursor |
| `o` / `O` | New line below / above |
| `dd` | Delete line |
| `yy` | Copy (yank) line |
| `p` | Paste after cursor |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `ciw` | Change inner word (delete word + enter insert mode) |
| `ci"` | Change inside quotes |
| `di(` | Delete inside parentheses |

### Search

| Key | Action |
|-----|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` / `N` | Next / previous match (auto-centers) |
| `Esc` | Clear search highlighting |

## Splits

| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Navigate between splits |
| `:vs` | Vertical split |
| `:sp` | Horizontal split |

## Telescope (fuzzy finder)

Telescope is the primary way to navigate files and code. All searches are fuzzy.

```
Space f     → find files (respects .gitignore)
Space g     → grep across all files (uses ripgrep)
Space b     → switch buffers
Space /     → search within current file
```

Inside telescope:
- Type to filter results
- `Ctrl+n` / `Ctrl+p` to move up/down
- `Enter` to open
- `Esc` to close

## Plugins installed

| Plugin | What it does |
|--------|-------------|
| **catppuccin** | Color theme matching Ghostty |
| **telescope.nvim** | Fuzzy finder for files, grep, buffers |
| **nvim-treesitter** | Syntax highlighting for JS/TS/JSON/YAML/Python/Lua/Markdown/Bash/HTML/CSS |
| **lazy.nvim** | Plugin manager (auto-bootstraps on first run) |

## Git commit authoring

When git opens Neovim for a commit message, special settings activate:
- Text wraps at 72 characters
- Color columns at 50 (subject) and 72 (body)
- Spell check enabled
- Starts in insert mode if the message is empty

This matches the conventional commit format in `.gitmessage`.

## File type behavior

| Language | Tab width |
|----------|-----------|
| JS/TS/JSON/YAML/TOML/Lua | 2 spaces |
| Python | 4 spaces |

## Config location

```
~/.config/nvim/init.lua    (symlinked from dotfiles)
```

Single-file config. Everything in one place -- no plugin directory sprawl.

## Common operations cheat sheet

```
v file.js           Open a file
:w                  Save
:q                  Quit
:wq                 Save and quit
:q!                 Quit without saving
Space f             Find and open a file
Space g             Search for text across files
dd                  Delete a line
yy p                Copy a line, paste it
u                   Undo
ciw                 Replace a word
/search             Find text in file
:%s/old/new/g       Find and replace in file
```
