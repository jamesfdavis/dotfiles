# Claude Code

Claude Code is the primary development tool. It reads the codebase, writes code, runs tests, and handles git operations.

## Aliases

```bash
cc      # claude (start session)
ccc     # claude chat (conversational mode)
ccr     # claude --resume (continue previous session)
cci     # claude init (initialize project config)
ccv     # claude --verbose
```

## Configuration

Claude Code reads config from `~/.claude/`, which is symlinked from the dotfiles:

```
~/.claude/
├── CLAUDE.md              # Global preferences (Mermaid, workflow, stack context)
└── commands/              # Slash commands available in every session
    ├── plan.md            # /plan — Research & design doc
    ├── milestone.md       # /milestone — Break plan into phases
    ├── issues.md          # /issues — Create GitHub issues
    └── tdd.md             # /tdd — Test-driven development
```

The global `CLAUDE.md` is intentionally lean (~35 lines). Per [context engineering best practices](https://www.humanlayer.dev/blog/writing-a-good-claude-md), fewer instructions means better instruction-following. Workflow details live in slash commands that only enter context when invoked.

## Developer Workflow

```mermaid
graph LR
    A[/plan] --> B[/milestone]
    B --> C[/issues]
    C --> D[/tdd]
    D --> E[Commit & PR]
```

1. **Plan** — Research the codebase, draft a design doc, get approval
2. **Milestone** — Break the approved plan into testable increments
3. **Issues** — Create GitHub issues from milestones using `gh` CLI
4. **TDD** — Write failing tests, implement until green, refactor
5. **Commit** — Conventional commits, PR via `gh pr create`

For small tasks, skip straight to `/tdd`. The workflow is composable, not rigid.

## Project Setup

Each project gets its own `CLAUDE.md` at the root. Use the template:

```bash
cp ~/.dotfiles/claude/project-CLAUDE.md.example ./CLAUDE.md
```

A good project CLAUDE.md covers the **WHAT** (structure, stack), **WHY** (purpose), and **HOW** (build, test, deploy). Keep it under 60 lines. Use progressive disclosure — point to docs instead of inlining content.

## PKM Integration

For persistent knowledge across projects, use a private Obsidian vault with Claude agents. See [14-claude-pkm.md](14-claude-pkm.md) for setup.

## Multi-Agent Patterns

For larger tasks, Claude Code orchestrates sub-agents automatically:
- One agent researches the codebase
- Another writes implementation
- Another writes tests

This happens via the `Task` tool when complexity warrants it.

## Debugging

```bash
cc
# "The D1 query in src/routes/users.ts is returning empty results.
#  The table schema is in migrations/0001_users.sql. Debug this."
```

Claude will read the relevant files, trace the issue, and propose a fix.
