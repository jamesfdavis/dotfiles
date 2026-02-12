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

## Workflow

### Starting a new feature
```bash
cd ~/projects/my-worker
cc
# "Add a /health endpoint that returns worker version from wrangler.toml"
```

Claude Code will:
1. Read the existing codebase
2. Write the implementation
3. Run `wrangler dev --local` to test
4. Commit when you approve

### Debugging
```bash
cc
# "The D1 query in src/routes/users.ts is returning empty results.
#  The table schema is in migrations/0001_users.sql. Debug this."
```

### Multi-agent patterns

For larger tasks, Claude Code can orchestrate sub-agents:
- One agent researches the codebase
- Another writes implementation
- Another writes tests

This happens automatically with the `Task` tool when complexity warrants it.

## Project setup

Run `claude init` in a new project to create a `CLAUDE.md` that gives the agent context about:
- Project structure
- Build/test commands
- Code style preferences
- Deployment process
