# GitHub CLI (gh)

`gh` is GitHub's official CLI. Handles PRs, issues, repos, and API calls without leaving the terminal.

## Authentication

```bash
gh auth login                   # one-time setup (SSH recommended)
gh auth status                  # check current auth
```

Once authenticated, `gh` also serves as the git credential helper (configured in `.gitconfig`).

## Pull requests

### Aliases

```bash
ghpr          # gh pr create
ghprl         # gh pr list
ghprv         # gh pr view
ghprw         # gh pr view --web (open in browser)
ghprc         # gh pr checkout <number>
ghprm         # gh pr merge
```

### Creating a PR

```bash
# Push your branch first
gp

# Create PR interactively
ghpr

# Create PR with title and body
gh pr create --title "Add health endpoint" --body "Returns worker version from wrangler.toml"

# Create draft PR
gh pr create --draft

# Create PR with reviewers
gh pr create --reviewer teammate1,teammate2
```

### Reviewing PRs

```bash
ghprl                           # list open PRs
ghprc 42                        # checkout PR #42 locally
gh pr diff 42                   # view PR diff
ghprw 42                        # open in browser for review
```

### Merging

```bash
ghprm                           # merge current branch's PR
gh pr merge 42 --squash         # squash merge PR #42
gh pr merge 42 --rebase         # rebase merge
gh pr merge 42 --delete-branch  # merge and delete branch
```

## Issues

### Aliases

```bash
ghis          # gh issue create
ghisl         # gh issue list
ghisv         # gh issue view
```

### Creating issues

```bash
ghis                            # interactive
gh issue create --title "Bug: login fails" --body "Steps to reproduce..."
gh issue create --label bug     # with label
```

### Viewing issues

```bash
ghisl                           # list open issues
ghisl --label bug               # filter by label
ghisv 15                        # view issue #15
```

## Repo operations

```bash
ghrepo                          # open repo in browser
ghbrowse                        # open repo in browser (shorter)
gh repo clone owner/repo        # clone a repo
gh repo fork owner/repo         # fork a repo
```

## GitHub API

`gh api` is powerful for anything the aliases don't cover:

```bash
# List PR comments
gh api repos/owner/repo/pulls/42/comments | jq '.[].body'

# Get repo info
gh api repos/owner/repo | jq '{stars: .stargazers_count, forks: .forks_count}'

# List workflow runs
gh api repos/owner/repo/actions/runs | jq '.workflow_runs[:5] | .[].name'

# Create a release
gh release create v1.0.0 --title "v1.0.0" --notes "Initial release"
```

## Completions

Zsh completions are configured in `.zshrc`:

```bash
eval "$(gh completion -s zsh)"
```

This gives tab-completion for all `gh` subcommands and flags.

## Typical workflow

```bash
# Start feature
gswc feature/health-endpoint    # create + switch branch
cc                              # let Claude Code implement it
# ... Claude writes code, runs tests ...

gp                              # push branch
ghpr                            # create PR
# ... review happens ...
ghprm                           # merge
gco main && gl                  # back to main, pull
```
