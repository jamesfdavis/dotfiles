# Milestone: Break Plan into Phases

Break the approved design into ordered milestones.

## Process

1. **Read the design doc** — Find the most recent design document in the conversation or at the path provided.

2. **Identify natural boundaries** — Group changes into milestones where each milestone:
   - Delivers a working, testable increment
   - Can be merged independently without breaking the build
   - Has clear acceptance criteria

3. **Structure each milestone** as:
   ```
   ## Milestone N: <title>
   **Goal**: What this milestone delivers
   **Files**: List of files to create/modify
   **Acceptance criteria**:
   - [ ] Specific, verifiable conditions
   - [ ] Tests that must pass
   **Depends on**: Previous milestone (if any)
   ```

4. **Present for review** — Show the milestone breakdown and wait for approval or adjustments.

## Rules

- Each milestone should be completable in a single focused session.
- First milestone should be the smallest possible working slice.
- Last milestone should include cleanup and documentation if needed.
- Use Mermaid diagrams to show milestone dependencies if non-linear.

## Context

$ARGUMENTS
