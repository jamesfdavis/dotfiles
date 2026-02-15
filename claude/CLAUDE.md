# Developer Preferences

Agent-first, terminal-native, Cloudflare-native development. Neovim as editor, Ghostty as terminal.

## Output

- Use Mermaid JS for all diagrams and charts. Never use ASCII art for diagrams.
- Keep responses concise. No emojis unless asked.

## Workflow

All features follow: Scaffold → Plan → Issues → Build → Verify.

Use the slash commands to drive each phase:
- `/scaffold` — Generate a new SvelteKit PWA + Cloudflare project with opinionated defaults
- `/plan` — Research codebase, draft a stack-aware design doc, get approval before coding
- `/issues` — Break approved plan into sized, ordered GitHub issues with dependency links
- `/build` — Implement with layered TDD: unit (vitest) → component (testing-library) → E2E (playwright/browser)
- `/verify` — Browser-based UI verification via `claude --chrome`

Skip steps when appropriate:
- Existing project? Skip `/scaffold`.
- Small fix? Skip `/plan` and `/issues`, go straight to `/build`.
- No UI changes? Skip `/verify`.

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

## Svelte 5 Rules

- Always use runes: `$state`, `$derived`, `$effect`.
- Never use legacy Svelte 4 patterns: `$:`, `writable()`, `readable()`, `derived()`.
- Server-side code goes in `src/lib/server/` or `+page.server.ts` / `+server.ts`.
- Components go in `src/lib/components/`, stores in `src/lib/stores/`.

## Testing Layers

| Layer | Tool | Location | Tests |
|-------|------|----------|-------|
| Unit | vitest | `tests/unit/` | Stores, utils, API handlers |
| Component | testing-library/svelte | `tests/component/` | Render, interaction, reactive state |
| E2E | playwright or Chrome | `tests/e2e/` | User flows, navigation, offline |

After making any frontend changes, visually verify in Chrome before reporting completion (if `claude --chrome` is available).

## LLM-Friendly Documentation (llms.txt)

When looking up framework or platform docs, prefer fetching llms.txt URLs over browsing full documentation sites. These are concise, LLM-optimized, and version-matched.

### Stack docs (curated)

| Library | URL | Notes |
|---------|-----|-------|
| SvelteKit | `https://svelte.dev/docs/kit/llms.txt` | SvelteKit-specific |
| Svelte | `https://svelte.dev/llms-small.txt` | Svelte 5 compressed |
| Svelte (full) | `https://svelte.dev/llms-full.txt` | Complete Svelte + SvelteKit |
| Cloudflare Workers | `https://developers.cloudflare.com/workers/llms-full.txt` | Workers API |
| Cloudflare Pages | `https://developers.cloudflare.com/pages/llms-full.txt` | Pages deployment |
| Cloudflare Agents | `https://developers.cloudflare.com/agents/llms-full.txt` | Agents SDK |
| Cloudflare (index) | `https://developers.cloudflare.com/llms.txt` | All products index |
| Vite | `https://vite.dev/llms.txt` | Build tooling |

Tailwind CSS v4 has no official llms.txt. Use training data or fetch docs manually.

For libraries not listed above, check `<domain>/llms.txt` or use the Cloudflare Docs MCP tool.

## Conventions

- Conventional commits: `<type>(<scope>): <description>`
- Test before commit. Verify changes compile and pass before suggesting a commit.
- Prefer `pnpm` for JS/TS projects, `uv` for Python projects.
