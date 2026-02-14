# Plan: Research & Design

Create a design document for the task described below, grounded in the SvelteKit + Cloudflare stack.

## Process

1. **Understand the request** — Read the task description. If anything is ambiguous, ask clarifying questions before proceeding.

2. **Research the codebase** — Spawn parallel research agents to:
   - Locate relevant files and modules
   - Understand existing patterns and conventions
   - Identify dependencies and integration points
   - Check for existing tests that cover related behavior

3. **Evaluate stack constraints** — Before drafting, explicitly consider:
   - **Svelte 5**: Does this need `$state`, `$derived`, or `$effect`? Any reactivity edge cases (fine-grained updates, cross-tab sync, derived chains)?
   - **Cloudflare Workers**: Does this hit platform limits (CPU time, memory, subrequest count)? Does it need D1, KV, R2, or Durable Objects?
   - **PWA**: Does this affect offline behavior, caching strategy, or the service worker? Does the manifest need updating?
   - **SSR vs CSR**: Should this render server-side (SEO, first paint) or client-only (interactive, auth-gated)?

4. **Draft the design** — Write a markdown design doc that includes:
   - **Goal**: One sentence describing the desired outcome
   - **Current state**: What exists today (with `file:line` references, not code snippets)
   - **Proposed changes**: Specific files to create/modify and why
   - **Data model**: D1 schema changes, KV key patterns, or R2 bucket structure if applicable
   - **Component tree**: Mermaid diagram of new/modified Svelte components
   - **Testing strategy**: What to test at each layer:
     - Unit (vitest): Pure logic, utilities, stores
     - Component (testing-library): Render, interaction, state
     - E2E (playwright): User flows, navigation, API integration
   - **Open questions**: Anything that needs human input before proceeding

5. **Present for approval** — Show the design doc and wait for explicit approval before any implementation begins.

## Rules

- Do NOT write any implementation code during planning.
- Prefer pointers (`file:line`) over pasting code into the plan.
- Use Mermaid diagrams for architecture, component trees, and data flow.
- If the task is small enough that a plan is overkill, say so and suggest skipping to `/build`.
- Always consider the PWA implications — even "backend-only" changes can affect caching and offline behavior.

## Task

$ARGUMENTS
