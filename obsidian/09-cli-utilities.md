# CLI Utilities

Modern replacements for classic Unix tools. All installed via Homebrew, all faster than the originals.

## bat (better cat)

Syntax-highlighted file viewer with line numbers and git integration.

### Aliases

```bash
cat             # → bat --paging=never (no scrolling, just output)
catp            # → bat (with paging, like less)
```

### Usage

```bash
cat file.js                 # syntax-highlighted output
cat -l json < data.txt      # force a language
catp long-file.js           # scroll through with paging
bat --diff file.js          # show git diff inline
```

### As man pager

`bat` is configured as the man page viewer in `.exports`:

```bash
man git         # renders with syntax highlighting and color
```

## eza (better ls)

Modern `ls` replacement with git awareness and tree view.

### Aliases

```bash
ls              # → eza
ll              # → eza -la --git (long listing with git status)
la              # → eza -a (show hidden files)
lt              # → eza --tree --level=2 (2-level tree)
```

### Usage

```bash
ls                          # clean file listing with color
ll                          # detailed listing with git status per file
lt                          # tree view of current directory
lt src/                     # tree view of specific directory
eza --tree --level=4        # deeper tree
```

The `tre` function in `.functions` goes further:

```bash
tre                         # 3-level tree, ignores .git/node_modules/dist/.wrangler
tre src/                    # tree a specific directory
```

### Git integration

`ll` shows git status per file:

```
.rw-r--r--  1.2k user  5 min -- .zshrc        M    (modified)
.rw-r--r--  428  user  2 days - .exports       --   (clean)
drwxr-xr-x     - user  1 hour - src/          N    (new/untracked)
```

## zoxide (better cd)

Smart directory jumper. Learns which directories you visit and ranks them by frequency + recency.

### Usage

```bash
z foo               # jump to most-used directory matching "foo"
z projects worker   # jump to directory matching both words
z ~/dotfiles        # works as a normal cd too
zi                  # interactive selection with FZF
```

### How it works

Zoxide maintains a database of every directory you `cd` into. When you type `z foo`, it finds the highest-ranked directory whose path contains "foo". After a few days of use, you can jump anywhere in 2-3 keystrokes.

### Tips

```bash
z dot               # probably jumps to ~/dotfiles
z src               # probably jumps to ~/src
z worker            # jumps to your most-used worker project
```

No training required -- it starts learning from the first `cd` you do.

## jq (JSON processor)

Command-line JSON processor. Essential for working with APIs and config files.

### Basic usage

```bash
# Pretty-print JSON
echo '{"a":1}' | jq .

# Extract a field
echo '{"name":"james","age":30}' | jq '.name'

# Array operations
echo '[1,2,3]' | jq '.[0]'           # first element
echo '[1,2,3]' | jq '.[]'            # iterate all
echo '[1,2,3]' | jq 'length'         # count
```

### Common patterns

```bash
# Parse API responses
curl -s https://api.example.com/data | jq '.results[].name'

# Extract from wrangler output
wrangler d1 list | jq '.[].name'

# Filter arrays
cat data.json | jq '.users[] | select(.active == true)'

# Transform shape
cat data.json | jq '{name: .user.name, email: .user.email}'

# Compact output (no pretty-print)
jq -c '.' < data.json
```

### With other tools

```bash
# Search JSON files
rg "pattern" --type json -l | xargs -I {} sh -c 'echo "--- {} ---" && jq . {}'

# GitHub API
gh api repos/owner/repo/pulls | jq '.[].title'
```

## Quick reference

| Old command | New command | Why |
|-------------|-------------|-----|
| `cat` | `bat` | Syntax highlighting, line numbers, git diff |
| `ls` | `eza` | Git status, tree view, color |
| `cd` + `cd -` | `zoxide` (z) | Learns your directories, fuzzy matching |
| `python -m json.tool` | `jq` | Full JSON query language, piping |
