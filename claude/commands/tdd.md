# TDD: Test-Driven Development

Implement the task using strict red-green-refactor TDD.

## Process

1. **Identify the scope** — Read the issue, milestone, or task description. Determine what behavior needs to exist.

2. **Red: Write failing tests first**
   - Write the minimum tests that describe the expected behavior
   - Run the tests and confirm they fail for the right reason
   - Do NOT write any implementation code yet

3. **Green: Make tests pass**
   - Write the simplest implementation that makes the failing tests pass
   - Run the full test suite to confirm nothing is broken
   - Do NOT add functionality beyond what the tests require

4. **Refactor: Clean up**
   - Improve the implementation without changing behavior
   - Run tests again to confirm they still pass
   - Remove duplication, improve naming, simplify logic

5. **Repeat** — If more behavior is needed, go back to step 2.

6. **Verify** — Run the full test suite and type checker before presenting the result.

## Rules

- Never write implementation before a failing test exists.
- Each red-green-refactor cycle should be small and focused.
- If you discover missing test infrastructure (fixtures, mocks, helpers), set that up first.
- Commit after each green phase if the change is meaningful.
- Use the project's existing test framework and patterns — check `package.json` or `pyproject.toml`.

## Task

$ARGUMENTS
