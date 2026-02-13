# Issues: Create GitHub Issues from Milestones

Turn approved milestones into GitHub issues.

## Process

1. **Read the milestones** — Find the milestone breakdown from the conversation or the path provided.

2. **For each milestone**, create a GitHub issue using `gh issue create`:
   - **Title**: Concise, imperative (e.g., "Add streaming support to AgentScope")
   - **Body**: Include the goal, files involved, and acceptance criteria as a checkbox list
   - **Labels**: Apply appropriate labels (e.g., `enhancement`, `bug`, `refactor`)
   - **Milestone**: Assign to a GitHub milestone if one exists

3. **Link issues** — If milestones depend on each other, reference the dependency in the issue body (e.g., "Blocked by #42").

4. **Report back** — List all created issues with their numbers and URLs.

## Issue body template

```markdown
## Goal
<one sentence from milestone>

## Changes
<files to create/modify>

## Acceptance Criteria
- [ ] <criteria from milestone>
- [ ] All tests pass
- [ ] Types check clean

## Context
Part of: <link to parent issue or design doc if applicable>
```

## Rules

- Always confirm the repository and milestone list before creating issues.
- Do not create duplicate issues — check existing issues first with `gh issue list`.
- Use conventional labels that already exist in the repo.

## Context

$ARGUMENTS
