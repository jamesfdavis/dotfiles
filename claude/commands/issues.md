# Issues: Break Plan into GitHub Issues

Break the approved design into sized, ordered GitHub issues with dependency links.

## Process

1. **Read the design doc** — Find the most recent approved design document in the conversation or at the path provided.

2. **Identify work units** — Break the design into issues where each issue:
   - Delivers a working, testable increment
   - Can be merged independently without breaking the build
   - Is completable in a single focused session
   - Has clear acceptance criteria

3. **Size and order** — Apply these constraints:
   - First issue should be the smallest possible working slice (data model + one route, or a single component with tests)
   - Each subsequent issue builds on the previous
   - Group related changes — don't split a component from its tests
   - Final issue includes cleanup: remove scaffolding, update project CLAUDE.md

4. **Check for duplicates** — Run `gh issue list` to avoid creating duplicates.

5. **Create issues** — For each work unit, run `gh issue create` with:

   ```markdown
   ## Goal
   <one sentence describing what this issue delivers>

   ## Changes
   <files to create/modify with brief rationale>

   ## Acceptance Criteria
   - [ ] <specific, verifiable condition>
   - [ ] Unit tests pass (vitest)
   - [ ] Component tests pass (testing-library) — if UI is involved
   - [ ] Types check clean (pnpm check)
   - [ ] PWA still works offline — if caching/SW affected

   ## Dependencies
   Blocked by: #<issue_number> (if applicable)
   Part of: <link to parent issue or design doc>
   ```

   - **Labels**: Apply appropriate labels (`enhancement`, `bug`, `refactor`, etc.)
   - **Milestone**: Assign to a GitHub milestone if one exists

6. **Report back** — List all created issues with numbers, titles, and URLs. Show the dependency graph as a Mermaid diagram.

## Rules

- Always confirm the repository before creating issues.
- Use conventional labels that already exist in the repo.
- Each issue must be independently mergeable — no issue should leave the build broken.
- Include testing expectations in every acceptance criteria block.
- If the plan has fewer than 3 issues worth of work, suggest skipping straight to `/build`.

## Context

$ARGUMENTS
