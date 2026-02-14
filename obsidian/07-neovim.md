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

### Comment toggling (mini.comment)

| Key | Action |
|-----|--------|
| `gcc` | Toggle comment on current line |
| `gc` + motion | Toggle comment on motion (e.g. `gcap` for paragraph) |
| `gc` (visual) | Toggle comment on selection |

### Jump anywhere (flash.nvim)

| Key | Action |
|-----|--------|
| `s` + 2 chars | Flash jump — type two characters, then a label to jump |
| `S` | Flash Treesitter — select treesitter nodes |

Flash replaces multi-step `/search` workflows for in-view navigation. Press `s`, type two characters from where you want to go, and press the highlighted label.

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

| Language | Server | What it catches |
|----------|--------|-----------------|
| JavaScript/TypeScript | ts_ls | Type errors, missing imports, bad references |
| JavaScript/TypeScript | eslint | Lint rules, unused vars, React hooks, style |
| Svelte | svelte | `.svelte` files — script, template, and style blocks |
| Python | pyright | Type errors, missing imports |
| Lua | lua_ls (Neovim-aware) | Lua/Neovim API errors |

All servers are auto-installed by Mason on first launch. ESLint reads your project's `.eslintrc.*` or `eslint.config.*` — no extra setup needed. Use `gra` on any ESLint diagnostic to apply the suggested fix.

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
| **mini.comment** | Toggle comments with `gcc` / `gc` + motion |
| **mini.pairs** | Auto-close brackets, quotes, backticks |
| **mini.statusline** | Lightweight status bar |
| **flash.nvim** | Jump anywhere with `s` + 2 chars |
| **guess-indent.nvim** | Auto-detects file indentation |
| **nvim-web-devicons** | File type icons (Nerd Font) |
| **lazy.nvim** | Plugin manager (auto-bootstraps on first run) |

## How to review Claude-generated code

This is the core workflow for steering Claude and reviewing its output as fast as possible. The goal: see exactly what changed, verify correctness with LSP, accept or reject at the hunk level, and commit only what you approve.

### Step 1: See everything that changed

```
Space gd
```

Opens diffview — a side-by-side diff of every file Claude modified. The left panel lists changed files, the right shows the diff. This is your starting point for every review.

**Navigate between files:**

| Key | Action |
|-----|--------|
| `Tab` | Next changed file |
| `Shift+Tab` | Previous changed file |
| `Enter` | Open diff for selected file |
| `Space gc` | Close diffview when done |

### Step 2: Walk through hunks

Inside a file, hunks are the individual blocks of changed code. Jump between them instead of scrolling:

| Key | Action |
|-----|--------|
| `]h` | Jump to next hunk |
| `[h` | Jump to previous hunk |
| `Space hp` | Preview hunk as an inline popup (quick glance without leaving your position) |

### Step 3: Check for errors

LSP catches problems Claude introduced — type errors, missing imports, bad references, ESLint violations — without running anything:

| Key | Action |
|-----|--------|
| `]d` | Jump to next diagnostic (error/warning) |
| `[d` | Jump to previous diagnostic |
| `Space sd` | Search ALL diagnostics across every file in the project |
| `gra` | Apply a quick fix (ESLint auto-fix, add missing import, etc.) |

### Step 4: Verify correctness

When something looks suspicious, dig deeper:

| Key | Action |
|-----|--------|
| `grd` | Go to definition — verify the function/variable Claude referenced actually exists |
| `grr` | Find all references — check if Claude missed updating a call site |
| `gri` | Go to implementation — see the actual code behind an interface |
| `Space sw` | Search for the word under cursor across the entire project |
| `Space sg` | Grep for any pattern — find old names that should have been renamed |

### Step 5: Accept or reject each change

This is the key to a tight feedback loop. You don't have to accept or reject an entire file — you work at the **hunk level**:

**Accept a change (stage it):**
```
Space hs        Stage this hunk — you're keeping it
```

**Reject a change (discard it):**
```
Space hr        Reset this hunk — reverts it to what was there before
```

**Partial hunks — accept or reject specific lines within a hunk:**
1. Enter visual mode: `V` then `j`/`k` to select lines
2. `Space hs` to stage just those lines
3. Or `Space hr` to reset just those lines

**Whole file shortcuts:**

| Key | Action |
|-----|--------|
| `Space hS` | Stage entire buffer (accept all changes in this file) |
| `Space hR` | Reset entire buffer (discard all changes in this file) |
| `Space hu` | Undo last stage (if you staged a hunk by mistake) |

### Step 6: Verify what you staged

Before committing, confirm you only staged what you intended:

```
Space hd        Diff this file against the index — see what's staged vs not
Space gd        Re-open diffview to scan remaining unstaged changes
```

### Step 7: Commit only approved changes

After staging the hunks you want, commit from the terminal or lazygit:

```bash
# From terminal
git commit

# Or use lazygit (alias: lg) for a visual staging/commit interface
lg
```

Neovim opens for the commit message with spell check, 72-char wrapping, and auto-insert mode.

### Quick reference card

The full review loop in one block:

```
Space gd            1. Open side-by-side diff
Tab / Shift+Tab     2. Cycle through changed files
]h / [h             3. Walk through hunks
Space hp            4. Preview a hunk inline
]d / [d             5. Check for LSP errors
grd / grr           6. Verify definitions and references
Space hs            7. Stage hunk (accept)
Space hr            8. Reset hunk (reject)
V + j/k + Space hs  9. Stage partial hunk (accept specific lines)
V + j/k + Space hr  10. Reset partial hunk (reject specific lines)
Space gc            11. Close diffview
git commit          12. Commit what you staged
```

### Tips for speed

- **Don't read every line.** Use `]h` to hop between hunks — the gutter signs (`+`/`~`/`_`) show you where to look.
- **Trust the LSP.** If there are zero diagnostics after `Space sd`, type-level correctness is confirmed. Focus your eyeballs on logic, not syntax.
- **Use `grr` on anything Claude renamed.** If references count matches what you expect, the rename was complete.
- **Reject first, ask later.** If a hunk looks wrong, `Space hr` immediately. You can always ask Claude to redo just that part. Faster than trying to manually fix it.
- **Partial hunks for mixed changes.** Claude often adds something good and something unnecessary in the same block. `V` select the good lines, `Space hs`, then `Space hr` the rest.
- **`Space sg` is your safety net.** After Claude does a rename or refactor, grep for the old name. If it shows up anywhere, Claude missed a spot.

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
gcc                 Toggle comment on line
gcap                Comment a paragraph
s{2chars}           Flash jump to any visible location
/search             Find text in file
:%s/old/new/g       Find and replace in file
:Lazy               Open plugin manager
:Mason              Open LSP/tool installer
:ConformInfo        Check formatter status
```
