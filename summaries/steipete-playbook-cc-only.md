# Replicating Steinberger's Throughput on Claude Code Max ($200/mo)

Steinberger's speed comes from 10 specific practices. None of them require
OpenAI. Here's how to replicate each one using only Claude Code Max.

---

## 1. Parallel Agents in Ghostty (not tmux)

Steinberger runs 3-8 agents in a tmux 3x3 grid. You already have Ghostty with
split keybindings. Use them.

**Setup:**
```
# Ghostty splits (already in your config)
Cmd+Alt+Right    → new split right
Cmd+Alt+Down     → new split down
Cmd+Alt+Arrows   → navigate splits
```

**Workflow:**
- Open 3-4 Ghostty splits, each running `claude` in the same project
- Give each agent a different scoped task (see #4 below)
- Watch all streams simultaneously -- intervene only when one drifts

**Why this works on Max:** The $200/mo plan is token-based, not
instance-based. Running 4 agents in parallel burns tokens 4x faster but
finishes 4x sooner. Same total cost, faster wall-clock time.

**Model selection per split:**
- Use `claude --model sonnet` for routine implementation (cheaper, fast)
- Use `claude --model opus` for architecture, complex refactors
- Use `claude --model haiku` for boilerplate, simple file generation
- This mimics Steinberger's multi-model approach within one provider

---

## 2. Conversational Prompting (Loosen the Pipeline)

Steinberger's core advice: "just talk to it." Your current pipeline
(`/scaffold` -> `/plan` -> `/issues` -> `/build` -> `/verify`) is great for
quality but adds ceremony.

**When to use your pipeline:** New features, greenfield projects, anything
touching architecture.

**When to go conversational:** Bug fixes, small features, refactoring,
exploration. Skip the slash commands and just talk:

```
# Instead of:
/plan
Here's the spec for adding dark mode...

# Do:
The settings page needs a dark mode toggle. Give me two options
for state management -- one using Svelte context, one using a store.
Let's discuss before coding.
```

The key phrase is **"give me options"** or **"discuss before coding."** This
gets you Steinberger's collaborative iteration without abandoning your
structured approach for big work.

---

## 3. Let the Agent Maintain CLAUDE.md

Steinberger's ~800-line rules file is "organizational scar tissue" -- the agent
adds rules whenever something goes wrong. You currently hand-maintain yours.

**Adopt this practice:**
```
When a mistake happens, tell Claude:

"Add a rule to CLAUDE.md that prevents this from happening again.
Keep it concise -- one line."
```

Over time your CLAUDE.md grows organically with hard-won lessons. The rules
become more precise because they come from real failures, not theoretical best
practices.

**Guard rail:** Periodically review CLAUDE.md yourself. Prune rules that
conflict or are no longer relevant. Steinberger's file is ~800 lines -- yours
should grow but stay curated.

---

## 4. Blast Radius Thinking (Task Scoping)

This is how Steinberger makes parallel agents safe. Each agent gets a task
scoped to limit what it can break.

**Good scoping for parallel agents:**
```
Split 1: "Add the dark mode toggle component in src/lib/components/ThemeToggle.svelte"
Split 2: "Write unit tests for the theme store in tests/unit/theme.test.ts"
Split 3: "Update the settings page layout in src/routes/settings/+page.svelte"
```

**Bad scoping (overlapping blast radius):**
```
Split 1: "Add dark mode to the app"
Split 2: "Refactor the settings page"
# Both will touch the same files → merge conflicts
```

**Rule of thumb:** Each parallel agent should touch different files. If two
tasks might edit the same file, run them sequentially.

---

## 5. Cross-Project Referencing

Steinberger points agents at other project folders to reuse solved patterns.
Claude Code supports this natively.

**How:**
```bash
# Start Claude with access to another project
claude --add-dir /path/to/other-project

# Or mid-conversation:
"Look at how /path/to/other-project/src/lib/auth.ts handles session tokens.
Implement the same pattern here."
```

This replaces re-explaining solved problems. The agent reads the reference
implementation and adapts it.

---

## 6. CLI-First Development (Already There)

You're already CLI-first with Wrangler, gh, lazygit, ripgrep, etc. This is one
of Steinberger's strongest recommendations. Agents can run CLIs, read error
output, and self-correct. No changes needed.

**One enhancement:** When building new features, consider building the CLI
interface first, then the UI. Agents can test CLIs autonomously. UIs require
human eyes (or your `/verify` command).

---

## 7. 20% Refactoring Cycle

Steinberger dedicates ~20% of agent time to code health. You don't have this
formalized.

**Add to your workflow:**

```bash
# Install the tools (add to Brewfile)
pnpm add -Dg jscpd    # code duplication detection
pnpm add -Dg knip     # dead code / unused exports
```

**Weekly refactoring prompt:**
```
Run these checks and fix what you find:
1. npx jscpd src/ --min-lines 5 --reporters console
2. npx knip --no-progress
3. npx eslint src/ --fix
4. Check for dependency updates: pnpm outdated
5. Look for TODO/FIXME/HACK comments and resolve them
```

This keeps agent-generated code from accumulating debt. Without it, parallel
agents compound complexity faster than a single agent would.

---

## 8. Structure Over Correctness

Steinberger's strongest insight: folder layout and module boundaries matter more
than prompt precision. When the project structure is obvious, agents do the
right thing.

**You already have this** via your `/scaffold` command (SvelteKit conventions,
`src/lib/components/`, `src/lib/stores/`, etc.). Lean into it harder:

- Enforce consistent naming conventions in CLAUDE.md
- Add a rule: "Before creating a new file, check if an existing module already
  handles this concern"
- Keep `src/lib/` shallow -- agents navigate flat structures better than deep
  nesting

---

## 9. Ship Code You Don't Fully Read

This is the hardest mindset shift. Steinberger trusts agents and ships without
reading every line. The safety net is tests + structure, not code review.

**How to get there with your setup:**
- Your testing pipeline (vitest -> testing-library -> playwright) is already
  stronger than what Steinberger describes
- If tests pass and `/verify` shows correct UI, ship it
- Read code only when: tests fail, behavior is wrong, or you're touching
  architecture
- For routine features, watch the stream and intervene only on red flags

**Your advantage:** Your test-before-commit rule is a better safety net than
Steinberger's "watch the stream" approach. Trust it.

---

## 10. Atomic Agent Commits

Steinberger has agents commit their own work atomically. Your current flow
requires conventional commits with human review.

**Adapt:**
```
Add to CLAUDE.md:

"After completing a self-contained change, commit it immediately with a
conventional commit message. Don't batch multiple changes into one commit.
Each commit should be independently revertable."
```

This pairs well with parallel agents -- each agent commits its own scoped work.
You review the git log afterward instead of reviewing code in-flight.

---

## Putting It All Together

**Daily workflow on Claude Code Max $200/mo:**

```
Morning: Open Ghostty, 3-4 splits
├── Split 1 (opus): Architecture / complex feature
├── Split 2 (sonnet): Routine implementation
├── Split 3 (sonnet): Tests for split 1-2's work
└── Split 4 (haiku): Docs, boilerplate, config changes

Each agent:
1. Gets a blast-radius-scoped task (different files)
2. Commits atomically as it works
3. You watch streams, intervene on drift

Weekly: Run the 20% refactoring cycle across the codebase

Ongoing: When something breaks, tell the agent to add a rule to CLAUDE.md
```

**What you keep from your current setup:**
- `/scaffold` for new projects (it's genuinely useful)
- `/build` for complex features that need TDD discipline
- `/verify` for UI work
- CLAUDE.md with stack rules and llms.txt links
- gitleaks pre-commit hook
- All your CLI tools

**What you drop or loosen:**
- Sequential single-agent workflow -> parallel agents
- Mandatory pipeline for every task -> pipeline for big work, conversation for
  small work
- Hand-maintained CLAUDE.md -> agent-maintained with periodic human review
- Reading all code before shipping -> trust tests, read selectively

**Estimated throughput gain:** 3-4x over single-agent sequential workflow, based
on parallelism alone. Conversational prompting for small tasks saves additional
ceremony overhead. All within one $200/mo subscription.
