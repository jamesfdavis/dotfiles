# SvelteKit + Cloudflare Project Guide

Include this file in project-level CLAUDE.md for SvelteKit + Cloudflare projects.

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
