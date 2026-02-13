# Git Workflow

## Tools

- **lazygit** (`lg`) -- terminal UI for staging, committing, branching, rebasing
- **gh** -- GitHub CLI for PRs, issues, releases
- **SSH signing** -- all commits are cryptographically signed

## Day to day

### lazygit
```bash
lg  # opens the TUI
```

lazygit handles:
- Interactive staging (line-by-line if needed)
- Commit with message
- Branch management
- Interactive rebase
- Stash management
- Merge conflict resolution

### Quick git aliases
```bash
gs      # git status
ga      # git add
gcm     # git commit -m
gp      # git push
gl      # git pull
gd      # git diff
gds     # git diff --staged
glog    # oneline graph log
uncommit # undo last commit, keep changes
```

### GitHub CLI
```bash
ghpr    # gh pr create
ghprl   # gh pr list
ghprw   # gh pr view --web
ghprc   # gh pr checkout
ghprm   # gh pr merge
ghis    # gh issue create
ghisl   # gh issue list
ghbrowse # open repo in browser
```

## Commit signing

Every commit is signed with SSH. Two-key architecture:

| Key | File | Purpose |
|-----|------|---------|
| Auth | `~/.ssh/id_ed25519` | Push/pull to GitHub |
| Signing | `~/.ssh/id_ed25519_signing` | Sign commits + tags |

Both registered on GitHub under Settings > SSH Keys. Commits show a green "Verified" badge.

See `docs/KEYS.md` for the full setup guide.

## Branch strategy

- `main` is always deployable
- Feature branches off main
- PRs via `ghpr`, merge via `ghprm`
- `git cleanup` alias removes merged branches

## Git config highlights

- `pull.rebase = true` -- no merge commits on pull
- `push.autoSetupRemote = true` -- push sets upstream automatically
- `rerere.enabled = true` -- remember conflict resolutions
- `rebase.autoSquash = true` -- fixup commits auto-squash
- `branch.sort = -committerdate` -- most recent branches first
