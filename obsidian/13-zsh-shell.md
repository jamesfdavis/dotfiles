# Zsh Shell

Zsh is the default macOS shell. The dotfiles configure it for fast startup, smart history, and minimal-but-powerful plugins.

## Config files

| File | Purpose |
|------|---------|
| `.zshrc` | Main shell config (plugins, path, integrations) |
| `.exports` | Environment variables |
| `.aliases` | Command shortcuts |
| `.functions` | Shell functions |
| `.extra` | Personal secrets (not committed to git) |
| `.inputrc` | Readline / input behavior |

Shell loads in this order: `.zshrc` → `.exports` → `.aliases` → `.functions` → `.extra`

## Plugins

Four plugins, all installed via Homebrew (not Oh My Zsh):

| Plugin | What it does |
|--------|-------------|
| **zsh-autosuggestions** | Ghost text suggestions from history as you type. Press `→` to accept. |
| **zsh-syntax-highlighting** | Colors commands green (valid) or red (invalid) as you type. |
| **zsh-history-substring-search** | Type a partial command, press `↑`/`↓` to cycle matching history. |
| **sudo widget** | Double-tap `Esc` to prepend/remove `sudo` on the current line. |

### History substring search

This is different from `Ctrl+R` (FZF fuzzy search). It filters by prefix:

```
docker ↑        → cycles through commands starting with "docker"
git log ↑       → cycles through commands starting with "git log"
npm run ↑       → cycles through commands starting with "npm run"
```

Use `Ctrl+R` for fuzzy search across the full command, `↑` for prefix-based recall.

### Sudo widget

```
$ systemctl restart nginx       # realize you need sudo
$ Esc Esc                       # becomes:
$ sudo systemctl restart nginx
```

Double-tap `Esc` again to remove the `sudo` prefix.

## History

```bash
HISTSIZE=50000          # commands in memory
SAVEHIST=50000          # commands saved to file
HISTFILE=~/.zsh_history
```

Options enabled:
- **HIST_IGNORE_ALL_DUPS** -- no duplicate entries
- **HIST_FIND_NO_DUPS** -- skip duplicates when searching
- **HIST_REDUCE_BLANKS** -- remove extra whitespace
- **SHARE_HISTORY** -- share history across terminal sessions
- **APPEND_HISTORY** -- append, don't overwrite

## Navigation options

```bash
AUTO_CD             # type a directory name to cd into it (no cd needed)
AUTO_PUSHD          # cd pushes to directory stack (use "cd -" to go back)
PUSHD_IGNORE_DUPS   # no duplicates in directory stack
EXTENDED_GLOB       # advanced pattern matching (e.g., ^*.js)
NO_CASE_GLOB        # case-insensitive globbing
```

### AUTO_CD in practice

```bash
..                  # goes up one directory (no cd needed)
...                 # goes up two directories
~/projects          # goes to ~/projects
```

## Completions

Completions are cached and only regenerated once per day:

```bash
compinit            # loaded once, cached in .zcompdump
gh completion       # GitHub CLI tab-completion
wrangler completion # Wrangler tab-completion
```

Homebrew's completions are added to FPATH automatically.

## Useful shell functions

Defined in `.functions`:

```bash
mkd mydir           # mkdir + cd into it
extract file.tar.gz # extract any archive format
tre                 # pretty tree (eza, 3 levels, ignores junk)
psgrep node         # find processes by name
killnamed node      # kill processes by name
myip                # get external IP
serve               # start HTTP server in current directory
serve 3000          # on a specific port
o                   # open current directory in Finder
cdf                 # cd to whatever Finder has open
cleanup             # delete node_modules/dist/.wrangler/.DS_Store recursively
genpass             # generate a 24-char secure password
genpass 32          # specify length
```

## Key aliases

### Navigation

```bash
..                  # cd ..
...                 # cd ../..
....                # cd ../../..
-                   # cd - (previous directory)
dl                  # cd ~/Downloads
dt                  # cd ~/Desktop
src                 # cd ~/src
p                   # cd ~/projects
dot                 # cd ~/dotfiles
```

### System

```bash
reload / rl         # restart shell
cls                 # clear
brewup              # update + upgrade + cleanup Homebrew
ports               # list listening ports
kill8787            # kill process on port 8787
ip                  # external IP
localip             # local IP
flushdns            # flush macOS DNS cache
showfiles/hidefiles # toggle hidden files in Finder
```

## Adding secrets

Create `~/.extra` for anything you don't want in git:

```bash
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export DATABASE_URL="postgres://..."
```

This file is sourced last and is in `.gitignore`.
