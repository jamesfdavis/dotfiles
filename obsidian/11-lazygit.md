# lazygit

Terminal UI for git. Handles staging, committing, branching, rebasing, stashing, and merge conflicts -- all without memorizing git commands.

## Opening

```bash
lg          # alias for lazygit
```

## Layout

lazygit opens a 5-panel interface:

```
┌─────────────┬──────────────────────────────┐
│ Status      │                              │
├─────────────┤                              │
│ Files       │      Diff / Preview          │
├─────────────┤                              │
│ Branches    │                              │
├─────────────┤                              │
│ Commits     │                              │
├─────────────┤                              │
│ Stash       │                              │
└─────────────┴──────────────────────────────┘
```

Navigate panels with **Tab** / **Shift+Tab** or **1-5** keys.

## Key operations

### Staging and committing

| Key | Action |
|-----|--------|
| `Space` | Stage/unstage a file |
| `a` | Stage/unstage all files |
| `Enter` | View file diff (line-by-line staging available) |
| `c` | Commit staged changes |
| `A` | Amend last commit |
| `S` | Squash commits (in commits panel) |

### Line-by-line staging

1. Select a file and press `Enter` to view its diff
2. Navigate to specific hunks or lines
3. Press `Space` to stage individual lines/hunks
4. Press `Esc` to go back, then `c` to commit

This is the killer feature -- stage exactly the changes you want without `git add -p`.

### Branching

| Key | Action |
|-----|--------|
| `n` | New branch |
| `Space` | Checkout branch |
| `d` | Delete branch |
| `M` | Merge into current |
| `r` | Rebase onto selected |

### Rebasing

1. Go to the Commits panel
2. Navigate to the commit you want to rebase from
3. Press `e` to start interactive rebase
4. `s` to squash, `f` to fixup, `d` to drop, `r` to reword
5. Once done, rebase applies automatically

### Stashing

| Key | Action |
|-----|--------|
| `s` (in files panel) | Stash changes |
| `Space` (in stash panel) | Apply stash |
| `g` (in stash panel) | Pop stash |
| `d` (in stash panel) | Drop stash |

### Merge conflicts

When conflicts exist, lazygit shows a side-by-side view:
- `←` / `→` to pick left (ours) or right (theirs)
- `b` to pick both
- `Space` to pick individual hunks

## Common workflows

### Quick commit
1. `lg` to open
2. `a` to stage all
3. `c` to commit, type message, `Enter`
4. `P` to push
5. `q` to quit

### Partial commit (some files, some lines)
1. `lg` to open
2. `Space` on each file to stage, or `Enter` to stage specific lines
3. `c` to commit
4. Repeat for next logical commit

### Reword old commit
1. Go to Commits panel
2. Navigate to the commit
3. Press `r` to reword

## When to use lazygit vs aliases

| Task | Use |
|------|-----|
| Quick status check | `gs` (alias) |
| Stage + commit everything | `gaa && gcm "msg"` (aliases) |
| Partial staging, rebasing, conflict resolution | `lg` (lazygit) |
| PR creation | `ghpr` (alias for gh CLI) |

lazygit excels at visual, interactive git operations. Aliases are faster for simple, known commands.
