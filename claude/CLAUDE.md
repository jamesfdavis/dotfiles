# Developer Preferences

Agent-first, terminal-native, Cloudflare-native development. Neovim as editor, Ghostty as terminal.

## Output

- Use Mermaid JS for all diagrams and charts. Never use ASCII art for diagrams.
- Keep responses concise. No emojis unless asked.

## Workflow

All features follow: Plan → Milestones → Issues → TDD → Implementation.

Use the slash commands to drive each phase:
- `/plan` — Research codebase, draft a design doc, get approval before coding
- `/milestone` — Break an approved plan into milestones with acceptance criteria
- `/issues` — Create GitHub issues from milestones using `gh` CLI
- `/tdd` — Write failing tests first, then implement until green

## Stack Quick Reference

| Layer | Tool |
|-------|------|
| Platform | Cloudflare Workers, D1, KV, R2, Pages |
| Frontend | SvelteKit, Svelte 5 |
| Backend | TypeScript on Workers |
| Python | uv, python 3.12 |
| Node | NVM with .nvmrc auto-switch |
| Git | SSH signing, lazygit, gh CLI |
| Shell | zsh + starship (no Oh My Zsh) |
| Search | ripgrep, fd, fzf |

## Conventions

- Conventional commits: `<type>(<scope>): <description>`
- Test before commit. Verify changes compile and pass before suggesting a commit.
- Prefer `pnpm` for JS/TS projects, `uv` for Python projects.
