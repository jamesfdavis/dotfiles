# Developer Preferences

Global instructions for all projects. Agent-first, terminal-native, Cloudflare-native development.

## Output

- Use Mermaid JS for all diagrams and charts. Never use ASCII art for diagrams.
- Keep responses concise. No emojis unless asked.

## Workflow

All features follow: Scaffold > Plan > Issues > Build > Verify. Scaffold a new project if needed, plan and get approval before coding, break work into GitHub issues, implement with layered TDD (unit > component > E2E), then visually verify UI changes in Chrome. Skip steps proportional to task size -- small fixes can go straight to build.

## Stack

| Layer | Tool |
|-------|------|
| Platform | Cloudflare Workers, D1, KV, R2, Pages |
| Frontend | SvelteKit, Svelte 5 (runes only) |
| CSS | Tailwind CSS v4 via `@tailwindcss/vite` |
| PWA | vite-plugin-pwa, workbox, service workers |
| Backend | TypeScript on Workers |
| Testing | vitest (unit), testing-library (component), playwright (E2E) |
| Python | uv, python 3.12 |
| Node | NVM with .nvmrc auto-switch |
| Git | SSH signing, lazygit, gh CLI |
| Shell | zsh + starship (no Oh My Zsh) |
| Search | ripgrep, fd, fzf |
| Browser | `claude --chrome` for UI verification feedback loop |

## Conventions

- Conventional commits: `<type>(<scope>): <description>`
- Test before commit. Verify changes compile and pass before suggesting a commit.
- Prefer `pnpm` for JS/TS projects, `uv` for Python projects.

## Project-Specific Docs

For SvelteKit + Cloudflare projects, see `claude/docs/sveltekit-cloudflare.md` for Svelte 5 rules, testing layers, and llms.txt references.
