# Svelte Shopping Cart: Bottlenecks & Browser Setup

## Bottlenecks for Rapid Generation

### 1. Scaffold & Config Overhead
No project template exists in the dotfiles repo. Every new project requires manual setup:
`npm create svelte@latest`, Cloudflare adapter wiring, D1 bindings, `wrangler.toml`, etc.

**Mitigation:** Create a reusable `/scaffold` slash command or cookiecutter template.

### 2. Blind UI Iteration
Claude Code is terminal-native. It generates Svelte components with zero visual feedback
on layout, responsive behavior, or animations. For a shopping cart where UX details matter
(quantity steppers, price formatting, empty-state, mobile drawer), this is the biggest bottleneck.

**Mitigation:** Enable `claude --chrome` for visual verification.

### 3. Svelte 5 Runes Edge Cases
Svelte 5's runes (`$state`, `$derived`, `$effect`) can produce subtle bugs in cart logic:
derived totals, persisted cart across tabs via `$effect` + localStorage, optimistic updates.

**Mitigation:** Use `/tdd` with component tests + browser runtime verification.

### 4. Backend Integration Gap
Shopping cart needs: product catalog (D1), cart persistence (KV/D1), image storage (R2),
and payment integration (Stripe). Testing the full flow requires `wrangler dev` + browser.

**Mitigation:** Browser access + `wrangler dev` running locally.

### 5. Context Loss Between Slash Commands
The `/plan` -> `/milestone` -> `/issues` -> `/tdd` workflow is sequential but stateless
between sessions. Architectural decisions can be lost.

**Mitigation:** Persist decisions in a design doc referenced by project `CLAUDE.md`.

---

## Browser Access Setup

### Option A: Claude in Chrome (Recommended)

First-party solution from Anthropic. No MCP config needed.

**Prerequisites:**
- Chrome or Edge
- Claude in Chrome extension v1.0.36+
- Claude Code v2.0.73+
- Anthropic plan (Pro, Max, Teams, or Enterprise)

```bash
# Launch with Chrome integration
claude --chrome

# Or enable permanently: /chrome → "Enabled by default"
```

**CLAUDE.md rule for automatic UI verification:**
```markdown
After making any frontend changes, open the page in Chrome and visually verify
the result before reporting completion.
```

### Option B: Playwright MCP (headless/CI)

```bash
claude mcp add --transport stdio playwright -- npx -y @playwright/mcp@latest
```

### Option C: Chrome DevTools MCP (debugging)

```bash
claude mcp add chrome-devtools --scope project npx chrome-devtools-mcp@latest
```

**Verify setup:** Run `/mcp` inside Claude Code to see connected servers.

---

## Quick Reference

| Bottleneck | Fix |
|---|---|
| No project scaffold | `/scaffold` slash command or template |
| Blind UI iteration | `claude --chrome` |
| Svelte 5 edge cases | `/tdd` + component tests + browser |
| Backend integration | Browser access + `wrangler dev` |
| Context loss | Design doc in project `CLAUDE.md` |
