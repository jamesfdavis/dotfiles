# Just Talk To It - the no-bs Way of Agentic Engineering

**Author:** Peter Steinberger
**Source:** https://steipete.me/posts/just-talk-to-it

## Core Thesis

Stop over-engineering your AI workflows. Don't waste time on RAG, subagent
frameworks, or elaborate orchestration tools. Instead, develop intuition by
directly conversing with AI agents -- treat them as collaborative partners, not
complex systems requiring middleware.

## Key Takeaways

### Talk Like a Human
Drop the "SCREAMING ALL-CAPS" prompt engineering and threatening language.
Just use natural words. Different models respond differently to tone -- GPT-5
actively dislikes aggressive prompting, while Claude historically responded to it.
The best approach is conversational.

### Conversational Over Rigid Plans
Instead of writing large specs and letting a model build for hours, discuss
options with the agent interactively. Ask it to "give me options" or "discuss"
before committing to an approach. Collaborative iteration beats waterfall-style
prompting.

### Agent Rules Files (CLAUDE.md / Agents.md)
Steinberger maintains an ~800-line rules file (symlinked as both `agents.md` and
`claude.md`) that acts as "organizational scar tissue." The agent itself writes
and maintains these rules -- whenever something goes wrong, it adds a concise
note to prevent recurrence.

### CLIs Over MCPs
Most MCP (Model Context Protocol) servers should just be CLIs. When an agent
runs a CLI and it fails, the help menu lands in context automatically, giving the
model full usage info. CLIs have no constant context cost unlike MCPs.

### Parallel Agents at Scale
Run 3-8 agent instances in parallel in a terminal grid (e.g., 3x3 tmux layout),
most operating in the same folder. This brute-force parallelism gets more done
than elaborate multi-agent orchestration. tmux handles background persistence.

### Atomic Commits & Clean Git History
Agents perform git atomic commits themselves, committing exactly the files they
edited. The rules file is iterated on to enforce clean commit hygiene.

### Blast Radius Thinking
Scope every task to limit the potential impact of any single agent's changes.
Think about what could go wrong and contain it.

### 20% Refactoring Cycle
Dedicate roughly 20% of time to agent-driven refactoring: code duplication
checks (jscpd), dead code removal (knip), ESLint fixes, API consolidation,
dependency updates, documentation, and test writing.

### Avoid Over-Engineering
Tools like Conductor, Terragon, and Sculptor are dismissed as thin wrappers
around current inefficiencies. They promote workflows that aren't optimal and
won't survive the next model generation.

## Context

Steinberger works solo on a ~300k LOC TypeScript/React app, a Chrome extension,
a CLI, a Tauri client app, and an Expo mobile app. Agentic engineering now writes
"pretty much 100%" of his code. The skills needed to manage agents mirror those
of senior software engineers -- architecture, system design, and knowing how to
scope and delegate work.

## Bottom Line

The best agentic engineering framework is no framework. Develop intuition through
direct interaction. The meta-skill is learning to communicate clearly and scope
work effectively -- the same skills that make a good engineering manager.
