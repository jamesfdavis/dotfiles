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

The leader key is **Space**. All custom shortcuts start with it. Press Space and wait to see all available keybindings via which-key.

### Quick actions

| Shortcut | Action |
|----------|--------|
| `Space w` | Save file |
| `Space q` | Quit |
| `Space f` | Format buffer (LSP/formatter) |
| `Space /` | Fuzzy search current file |
| `Space Space` | Switch between open buffers |

### Search (Space s)

All search commands use Telescope and are grouped under `Space s`:

| Shortcut | Action |
|----------|--------|
| `Space sf` | Search files (respects .gitignore) |
| `Space sg` | Search by grep across project (ripgrep) |
| `Space sh` | Search help tags |
| `Space sk` | Search keymaps |
| `Space ss` | Search select (Telescope builtins) |
| `Space sw` | Search current word under cursor |
| `Space sd` | Search diagnostics |
| `Space sr` | Resume last search |
| `Space s.` | Search recent files |
| `Space sc` | Search commands |
| `Space s/` | Live grep in open files |
| `Space sn` | Search neovim config files |

### LSP navigation (g prefix)

These keymaps activate when an LSP server attaches to a buffer:

| Shortcut | Action |
|----------|--------|
| `grd` | Go to definition |
| `grr` | Find references |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `grn` | Rename symbol |
| `gra` | Code action |
| `grD` | Go to declaration |
| `gO` | Document symbols |
| `gW` | Workspace symbols |

### Git (Space g) and Hunks (Space h)

**Diffview:**

| Shortcut | Action |
|----------|--------|
| `Space gd` | Open diff view (all working changes, side-by-side) |
| `Space gh` | File history for current file |
| `Space gH` | File history for entire repo |
| `Space gc` | Close diff view |

Inside diffview: `Tab`/`Shift+Tab` to cycle files, `Enter` to open a diff, `Space e` to focus file panel, `Space b` to toggle file panel.

**Hunk navigation and actions (gitsigns):**

| Shortcut | Action |
|----------|--------|
| `]h` / `[h` | Jump to next / previous hunk |
| `Space hp` | Preview hunk (inline popup) |
| `Space hs` | Stage hunk (accept this change) |
| `Space hu` | Undo stage hunk |
| `Space hr` | Reset hunk (discard this change) |
| `Space hS` | Stage entire buffer |
| `Space hR` | Reset entire buffer |
| `Space hb` | Blame line (who wrote this) |
| `Space hd` | Diff this file against index |

Visual mode: select lines then `Space hs` to stage or `Space hr` to reset just the selection.

### Toggle (Space t)

| Shortcut | Action |
|----------|--------|
| `Space th` | Toggle inlay hints |

### Diagnostics/Extras (Space x)

| Shortcut | Action |
|----------|--------|
| `Space xq` | Open diagnostic quickfix list |
| `Space xw` | Strip trailing whitespace |

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
| `Y` | Yank to end of line |
| `p` | Paste after cursor |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `ciw` | Change inner word (delete word + enter insert mode) |
| `ci"` | Change inside quotes |
| `di(` | Delete inside parentheses |

### Surround (mini.surround)

| Key | Action |
|-----|--------|
| `saiw)` | Surround add inner word with parens |
| `sd'` | Surround delete quotes |
| `sr)"` | Surround replace parens with quotes |

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

## Autocompletion

Autocompletion is powered by blink.cmp with LSP integration:

| Key | Action |
|-----|--------|
| `Ctrl+y` | Accept completion |
| `Ctrl+n` / `Ctrl+p` | Next / previous suggestion |
| `Ctrl+space` | Open completion menu / docs |
| `Ctrl+e` | Dismiss completion |
| `Ctrl+k` | Toggle signature help |
| `Tab` / `Shift+Tab` | Navigate snippet fields |

Documentation auto-shows after 250ms when a completion is highlighted.

## Auto-formatting

Files are auto-formatted on save using conform.nvim. Manual format with `Space f`.

| Language | Formatter |
|----------|-----------|
| Lua | stylua |
| JS/TS/JSON/YAML/HTML/CSS/Markdown | prettierd (falls back to prettier) |
| Python | black |

Formatters are auto-installed by Mason on first launch.

## LSP (Language Server Protocol)

LSP provides go-to-definition, references, rename, diagnostics, and more. Servers are auto-installed by Mason:

| Language | Server |
|----------|--------|
| JavaScript/TypeScript | ts_ls |
| Python | pyright |
| Lua | lua_ls (Neovim-aware) |

Diagnostics show inline as virtual text. Errors are underlined. Use `[d` / `]d` to jump between diagnostics (auto-opens float).

## Plugins installed

| Plugin | What it does |
|--------|-------------|
| **catppuccin** | Color theme matching Ghostty |
| **telescope.nvim** | Fuzzy finder for files, grep, LSP, buffers, help |
| **telescope-fzf-native** | Faster fuzzy matching in Telescope |
| **telescope-ui-select** | Telescope-powered selection menus |
| **nvim-treesitter** | Syntax highlighting for JS/TS/JSON/YAML/Python/Lua/Markdown/Bash/HTML/CSS and more |
| **nvim-lspconfig** | Language server configuration |
| **mason.nvim** | Auto-installs LSP servers and formatters |
| **fidget.nvim** | LSP progress notifications |
| **blink.cmp** | Autocompletion with LSP + snippets |
| **LuaSnip** | Snippet engine |
| **conform.nvim** | Auto-format on save |
| **diffview.nvim** | Side-by-side diff viewer and file history |
| **gitsigns.nvim** | Git change indicators in the gutter (+, ~, _) |
| **which-key.nvim** | Shows available keybindings after pressing a key |
| **todo-comments.nvim** | Highlights TODO/FIXME/HACK in comments |
| **mini.ai** | Better around/inside text objects |
| **mini.surround** | Add/delete/replace surrounding brackets, quotes |
| **mini.statusline** | Lightweight status bar |
| **guess-indent.nvim** | Auto-detects file indentation |
| **nvim-web-devicons** | File type icons (Nerd Font) |
| **lazy.nvim** | Plugin manager (auto-bootstraps on first run) |

## Reviewing Claude-generated code

Typical workflow after Claude makes changes:

```
Space gd            Open side-by-side diff of all working changes
Tab / Shift+Tab     Cycle through changed files
]h / [h             Jump between changed hunks
Space hp            Preview a hunk inline
]d / [d             Jump between diagnostics (errors/warnings)
Space sd            Search ALL diagnostics across the project
grd                 Jump into a definition to verify it exists
grr                 Find all references to check nothing was missed
Space sg            Grep for a pattern Claude might have missed
Space gc            Close diff view when done
```

Accepting or rejecting changes at the hunk level:
- `Space hs` — stage this hunk (accept it)
- `Space hr` — reset this hunk (discard it)
- Select lines in visual mode, then `Space hs` / `Space hr` for partial hunks
- `Space hS` — accept the entire file
- `Space hR` — discard the entire file

Quick audit checklist:
1. `Space gd` — scan the full diff, file by file
2. `]h` to walk through hunks, `Space hp` to preview each
3. `]d` in each file — check for LSP errors/warnings
4. `grr` on key symbols — confirm all call sites were updated
5. `Space sg` — search for old names/patterns that should have been replaced
6. `Space hs` / `Space hr` — accept or reject each hunk

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

guess-indent.nvim also auto-detects indentation from existing files.

## Config location

```
~/.config/nvim/init.lua    (symlinked from dotfiles)
```

Single-file config. Everything in one place -- no plugin directory sprawl.

## First launch

On first launch, lazy.nvim will auto-install all plugins and Mason will download LSP servers + formatters. This may take a minute. Run `:checkhealth` to verify everything is working.

## Common operations cheat sheet

```
v file.js           Open a file
:w                  Save
:q                  Quit
:wq                 Save and quit
:q!                 Quit without saving
Space sf            Find and open a file
Space sg            Search for text across files
Space f             Format current buffer
Space Space         Switch buffers
grd                 Go to definition
grr                 Find references
grn                 Rename symbol
dd                  Delete a line
yy p                Copy a line, paste it
u                   Undo
ciw                 Replace a word
saiw"               Surround word with quotes
/search             Find text in file
:%s/old/new/g       Find and replace in file
:Lazy               Open plugin manager
:Mason              Open LSP/tool installer
:ConformInfo        Check formatter status
```
