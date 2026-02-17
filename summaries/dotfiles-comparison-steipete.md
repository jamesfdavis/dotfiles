# Dotfiles & Stack Comparison: You vs. Peter Steinberger

A side-by-side comparison of your dotfiles layout and development stack against
what Peter Steinberger describes across his two posts:
- [Just Talk To It](https://steipete.me/posts/just-talk-to-it)
- [Shipping at Inference Speed](https://steipete.me/posts/2025/shipping-at-inference-speed)

---

## Layout & Configuration Philosophy

| Aspect | Your Dotfiles | Steinberger |
|--------|---------------|-------------|
| **Agent rules file** | `claude/CLAUDE.md` (~structured, per-project template) | `agents.md` symlinked to `claude.md` (~800 lines, "organizational scar tissue") |
| **Who writes the rules** | You wrote and maintain them | The agent writes and maintains them -- whenever something breaks, it adds a note |
| **Slash commands** | 5 custom commands (`/scaffold`, `/plan`, `/issues`, `/build`, `/verify`) + full skillchain system with 12 blueprints and 14 role categories | None mentioned -- prefers conversational prompting over structured commands |
| **Documentation** | Obsidian vault (16 guides), `docs/` folder, inline llms.txt links in CLAUDE.md | `docs/` folder per project, script that forces model to read docs on certain topics |
| **Workflow model** | Structured pipeline: scaffold -> plan -> issues -> build -> verify | Conversational: discuss -> iterate -> ship. No rigid pipeline |
| **Setup automation** | `install.sh` (8-step), `bootstrap.sh` (symlinks), 5 setup scripts | Not detailed -- focus is on runtime workflow, not bootstrap |
| **Git hooks** | `pre-commit` with gitleaks secret scanning | Agents do atomic commits; rules file enforces clean commit hygiene |

**Takeaway:** Your setup is more structured and prescriptive (explicit workflow stages, blueprints, role categories). Steinberger's is more conversational and emergent -- the agent evolves the rules organically. Both are heavily documentation-driven, but you front-load structure while he lets it accumulate.

---

## Development Stack

| Layer | Your Stack | Steinberger's Stack |
|-------|-----------|-------------------|
| **Primary language** | TypeScript (SvelteKit) | TypeScript (React), Go, Swift |
| **Frontend** | SvelteKit + Svelte 5 (runes) | React (~300k LOC app) |
| **Styling** | Tailwind CSS v4 | Not specified |
| **Platform** | Cloudflare (Workers, D1, KV, R2, Pages) | Not specified (likely mixed) |
| **Mobile** | None mentioned | Expo (React Native) |
| **Desktop** | None mentioned | Tauri |
| **Browser ext** | None mentioned | Chrome extension |
| **Testing** | vitest, testing-library, Playwright | Mentioned but not detailed |
| **AI agent** | Claude Code (sole agent) | Multi-model: Claude Code + OpenAI GPT-5/Codex (pragmatic per-task selection) |
| **Agent instances** | Single agent, sequential workflow | 3-8 parallel instances in tmux grid |
| **Terminal** | Ghostty | tmux (terminal not specified) |
| **Shell** | Zsh + Starship | Not detailed |
| **Editor** | Neovim (primary), VS Code (review) | Not detailed |
| **Git TUI** | lazygit | Not mentioned |
| **Containers** | Colima + Docker Compose | Not mentioned |
| **Secrets** | 1Password + gitleaks | Not detailed |
| **CLI tools** | ripgrep, fd, fzf, bat, eza, zoxide, jq | CLIs preferred over MCPs (specific tools not listed) |

**Takeaway:** Your stack is narrower and deeper -- all-in on Cloudflare + SvelteKit with a single AI agent. Steinberger's is wider -- multiple languages, multiple platforms (web, mobile, desktop, extension), multiple AI models running in parallel. You optimize for consistency; he optimizes for throughput.

---

## Agent Workflow Comparison

| Practice | Your Approach | Steinberger's Approach |
|----------|--------------|----------------------|
| **Agent count** | 1 agent at a time | 3-8 agents in parallel (tmux 3x3 grid) |
| **Agent model** | Claude Code only | Multi-model: Claude Code + GPT-5/Codex (best tool per task) |
| **Prompting style** | Structured slash commands + skillchain roles | Conversational ("just talk to it") |
| **Planning** | `/plan` command with stack constraints | "Discuss" and "give me options" -- no rigid plan mode |
| **Task scoping** | GitHub issues via `/issues` command | "Blast radius thinking" -- scope to limit impact |
| **Code review** | `/verify` with Chrome DevTools MCP | Watches stream, inspects key parts, mostly doesn't read |
| **MCPs** | Chrome DevTools MCP, Cloudflare Docs MCP | Dismisses MCPs as "marketing checkboxes" -- prefers CLIs |
| **Refactoring** | Not formalized | 20% cycle: jscpd, knip, ESLint, dependency updates |
| **Cross-project** | Per-project CLAUDE.md template | Points agent at other project folders to reuse solutions |
| **Git workflow** | Conventional commits, test-before-commit | Atomic commits by agents, clean history via rules file |

**Takeaway:** The biggest divergence is on MCPs and structured commands. You've invested heavily in MCP integrations and a command pipeline. Steinberger explicitly rejects MCPs in favor of CLIs and rejects structured commands in favor of conversation. Neither is wrong -- your approach adds guardrails; his maximizes speed and flexibility.

---

## Cost Comparison: Claude Code vs. OpenAI Codex

> **Note:** OpenAI Codex is OpenAI's cloud-based agentic coding tool (part of
> ChatGPT). Steinberger uses **both** Claude Code and OpenAI's models -- his
> `agents.md` symlinked to `claude.md` confirms Claude Code usage, while he
> credits GPT-5 as a quality unlock and references Codex for cross-project work.
> He's pragmatically multi-model, not locked to either provider.

### Subscription Plans

| Plan | Claude Code | GPT Codex (via ChatGPT) |
|------|-------------|------------------------|
| **Free** | Limited daily messages | Limited |
| **Pro ($20/mo)** | Claude Code access, standard limits | 30-150 messages / 5 hrs |
| **Max 5x ($100/mo)** | 5x Pro usage | -- |
| **Max 20x ($200/mo)** | 20x Pro usage | 300-1,500 messages / 5 hrs |
| **Team** | $150/seat/mo (Premium) | $25-30/seat/mo |

### API Token Pricing (per 1M tokens)

| Model | Input | Output |
|-------|-------|--------|
| **Claude Haiku 4.5** | $1.00 | $5.00 |
| **Claude Sonnet 4.5** | $3.00 | $15.00 |
| **Claude Opus 4.5** | $5.00 | $25.00 |
| **GPT-5.1-Codex-Mini** | $0.25 | $2.00 |
| **GPT-5.1-Codex** | $1.25 | $10.00 |
| **GPT-5.2-Codex** | $1.75 | $14.00 |

### Cost Analysis

**API pricing favors OpenAI at the low end:** GPT-5.1-Codex-Mini ($0.25/$2.00)
is 4x cheaper than Claude Haiku ($1.00/$5.00) for input, and 2.5x cheaper for
output. At the flagship tier, GPT-5.2-Codex ($1.75/$14.00) vs Claude Opus
($5.00/$25.00) -- OpenAI is ~3x cheaper on input and ~1.8x cheaper on output.

**Subscription pricing favors Claude for heavy use:** Both offer $20/mo Pro
tiers with Claude Code / Codex access. Claude's Max $200/mo plan gives 20x
usage, which real-world tests show saves ~18x vs API costs for heavy coding
(API costs can exceed $3,650/mo for power users). OpenAI's $200/mo Pro tier
gives 300-1,500 messages/5hrs but limits are message-based, not token-based.

**Hidden costs matter:**
- Claude Code sends large context windows with every request, making API
  pricing very expensive for coding workflows
- OpenAI's reasoning tokens (invisible via API) are billed as output tokens,
  inflating costs on complex tasks
- Both offer prompt caching (90% discount on cache hits for OpenAI, 90% for
  Claude cache reads)
- Claude offers 50% batch processing discount for non-urgent tasks

**Steinberger's cost profile:** Running 3-8 parallel agent instances (Claude Code
and/or OpenAI Codex) burning tokens constantly. He uses a multi-model approach,
picking the best tool per task and language. At API rates this would be extremely
expensive across either provider. He likely uses subscription plans for both
($200/mo Claude Max + $200/mo ChatGPT Pro), making parallel agents cost-effective
within their respective limits.

**Your cost profile:** Single Claude Code agent with structured commands that
reduce wasted tokens. The Max $200/mo plan is the sweet spot for heavy daily
use. Your slash commands and skillchain likely produce more focused prompts,
reducing per-task token consumption vs. conversational back-and-forth.

### Bottom Line on Cost

| Scenario | Cheaper Option | Why |
|----------|---------------|-----|
| Light use (API) | GPT Codex Mini | $0.25/1M input vs $1.00 |
| Heavy use (API) | GPT Codex | ~2-3x cheaper per token at flagship tier |
| Heavy use (subscription) | Roughly equal | Both ~$200/mo for power users |
| Parallel agents | GPT Codex (subscription) | Message-based limits suit parallel workflows |
| Single agent, deep context | Claude Code (subscription) | Token-based limits favor focused, long sessions |
| Team pricing | GPT Codex | $25-30/seat vs $150/seat for Claude premium |

---

## Summary

Your dotfiles represent a **structured, single-agent, Cloudflare-native**
workflow with explicit guardrails (slash commands, blueprints, MCPs, testing
pipeline). Steinberger's setup is a **conversational, multi-agent, multi-platform**
workflow that prioritizes speed and parallelism over structure.

Neither is objectively better -- they reflect different contexts:
- **You:** Solo developer shipping Cloudflare apps with consistency and quality
  gates. One agent, deep context, structured pipeline.
- **Steinberger:** Solo developer shipping across 5+ surfaces (web, mobile,
  desktop, extension, CLI) at maximum velocity. Many agents, shallow context,
  conversational iteration.

On cost: OpenAI is cheaper per-token at every tier, but subscription economics
roughly equalize at the $200/mo power-user level. Your structured approach likely
burns fewer tokens per task; his parallel approach burns more but ships faster
across a wider surface area.
