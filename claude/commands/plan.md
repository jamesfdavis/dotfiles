# Plan: Research & Design

Create a design document for the task described below.

## Process

1. **Understand the request** — Read the task description. If anything is ambiguous, ask clarifying questions before proceeding.

2. **Research the codebase** — Spawn parallel research agents to:
   - Locate relevant files and modules
   - Understand existing patterns and conventions
   - Identify dependencies and integration points
   - Check for existing tests that cover related behavior

3. **Draft the design** — Write a markdown design doc that includes:
   - **Goal**: One sentence describing the desired outcome
   - **Current state**: What exists today (with `file:line` references, not code snippets)
   - **Proposed changes**: Specific files to create/modify and why
   - **Testing strategy**: What tests to write and how to verify
   - **Open questions**: Anything that needs human input before proceeding

4. **Present for approval** — Show the design doc and wait for explicit approval before any implementation begins.

## Rules

- Do NOT write any implementation code during planning.
- Prefer pointers (`file:line`) over pasting code into the plan.
- Use Mermaid diagrams for architecture or flow visualization.
- If the task is small enough that a plan is overkill, say so and suggest skipping to `/tdd`.

## Task

$ARGUMENTS
