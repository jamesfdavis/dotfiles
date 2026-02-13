# FZF + Ripgrep + fd

Three Rust/Go tools that replace slow Unix defaults for finding files and searching code.

## FZF (fuzzy finder)

FZF adds interactive fuzzy search to everything. Installed via Homebrew, integrated into zsh.

### Shell keybindings

| Shortcut | Action |
|----------|--------|
| `Ctrl+R` | Search command history (replaces default reverse search) |
| `Ctrl+T` | Find a file and insert its path |
| `Alt+C` | cd into a directory |

`Ctrl+R` is the one you'll use most. Start typing any fragment of a past command and FZF narrows it down instantly.

### Piping into FZF

FZF shines when piped:

```bash
# Pick a branch to checkout
git branch | fzf | xargs git checkout

# Pick a process to kill
ps aux | fzf | awk '{print $2}' | xargs kill

# Open a file in nvim
v $(fzf)

# Pick a docker container
docker ps | fzf | awk '{print $1}' | xargs docker logs -f
```

### Configuration

Set in `.exports`:

```bash
FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info"
```

FZF uses `fd` as its file source (fast, respects .gitignore) instead of the default `find`.

## Ripgrep (rg)

Fast code search. Replaces `grep -r`. Respects `.gitignore` by default.

### Basic usage

```bash
rg "pattern"                    # search all files recursively
rg "TODO" --type js             # only JavaScript files
rg "function" src/              # only in src/ directory
rg -i "error"                   # case insensitive
rg -l "import"                  # list filenames only (no content)
rg "class \w+" --type ts        # regex: find class declarations
rg -C 3 "bug"                   # show 3 lines of context
rg --no-ignore "secret"         # include gitignored files
```

### Common patterns

```bash
# Find all TODO/FIXME comments
rg "TODO|FIXME"

# Find function definitions
rg "function \w+|const \w+ = " --type js

# Find import statements for a module
rg "from ['\"]express['\"]" --type ts

# Search and replace (preview with --dry-run is not built in -- pipe to sed)
rg -l "oldName" | xargs sed -i '' 's/oldName/newName/g'
```

### Config

`~/.ripgreprc` sets defaults:
- Search hidden files
- Respect `.gitignore`
- Smart case (case-insensitive unless pattern has uppercase)
- Line numbers on
- Max column width 200

### Neovim integration

Neovim uses ripgrep for `:grep` and Telescope's live grep (`Space g`). Same tool everywhere.

## fd (file finder)

Fast `find` replacement. Same authors as ripgrep.

### Basic usage

```bash
fd                              # list all files recursively
fd "\.js$"                      # find by extension (regex)
fd -e ts                        # find by extension (shorthand)
fd -e ts -e js                  # multiple extensions
fd -t d                         # directories only
fd -t f                         # files only
fd -H                           # include hidden files
fd "config" /etc                # search in specific directory
fd -x rm                        # execute command on each result
```

### Common patterns

```bash
# Find all TypeScript files
fd -e ts -e tsx

# Find config files
fd "config|\.env" -H

# Find and delete .DS_Store files
fd -H ".DS_Store" -x rm

# Find large files
fd -t f -x ls -lh {} \; | sort -k5 -h
```

## How they work together

```
fd    → finds files by name/path   → feeds FZF for interactive selection
rg    → finds files by content     → feeds FZF for interactive filtering
FZF   → adds fuzzy selection UI    → to any list piped into it
```

FZF's `Ctrl+T` and `Alt+C` use `fd` under the hood. Telescope in Neovim uses both `fd` and `rg`.
