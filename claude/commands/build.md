# Build: Implement with Layered TDD

Implement the task using test-driven development across three layers: unit, component, and E2E.

## Process

### Layer 1: Unit Tests (vitest)

Test pure logic in isolation — stores, utilities, data transformations, API handlers.

1. **Red** — Write failing tests in `tests/unit/`:
   - Svelte 5 stores: test `$state` and `$derived` values directly
   - Utility functions: test inputs/outputs
   - API route handlers: test with mock `platform.env` bindings
   - Run `pnpm test` — confirm tests fail for the right reason

2. **Green** — Write the minimum implementation to pass:
   - Stores in `src/lib/stores/` using runes
   - Utils in `src/lib/utils/`
   - Server logic in `src/lib/server/`
   - Run `pnpm test` — confirm all pass

3. **Refactor** — Clean up without changing behavior. Run tests again.

4. **Commit** — `git commit` after each meaningful green phase.

### Layer 2: Component Tests (testing-library)

Test Svelte components render correctly and respond to interaction.

1. **Red** — Write failing tests in `tests/component/`:
   ```typescript
   import { render, fireEvent } from '@testing-library/svelte';
   import Component from '$lib/components/Component.svelte';

   test('renders with initial state', () => {
     const { getByText } = render(Component, { props: { ... } });
     expect(getByText('...')).toBeInTheDocument();
   });
   ```
   - Test rendering with different props
   - Test user interactions (click, type, submit)
   - Test reactive updates ($state changes reflected in DOM)

2. **Green** — Build the component in `src/lib/components/` or `src/routes/`:
   - Use Svelte 5 runes, not legacy `$:` syntax
   - Keep components small and composable
   - Run `pnpm test` — confirm all pass

3. **Refactor** — Extract shared logic to stores, simplify templates. Run tests.

4. **Commit**.

### Layer 3: Integration / E2E (playwright or browser)

Test complete user flows through the running application.

1. **If Chrome is available** (`claude --chrome`):
   - Start dev server: `pnpm dev`
   - Navigate to the relevant page
   - Visually verify the layout, responsive behavior, and interactions
   - Check the browser console for errors or warnings
   - Test the flow end-to-end (e.g., add to cart → checkout → confirmation)
   - If issues are found, fix and re-verify

2. **If Chrome is NOT available** — Write Playwright tests in `tests/e2e/`:
   ```typescript
   test('user can complete checkout', async ({ page }) => {
     await page.goto('/');
     await page.click('[data-testid="add-to-cart"]');
     await page.click('[data-testid="checkout"]');
     await expect(page.locator('.confirmation')).toBeVisible();
   });
   ```
   - Run `pnpm test:e2e`

3. **Commit**.

### Final Verification

Before presenting the result:
- `pnpm test` — all unit and component tests pass
- `pnpm check` — TypeScript/Svelte types are clean
- `pnpm build` — production build succeeds
- `pnpm test:e2e` — E2E tests pass (if written)

## Rules

- Never write implementation before a failing test exists.
- Each red-green-refactor cycle should be small and focused.
- Use the project's existing test patterns — check `vitest.config.ts` and `package.json`.
- Svelte 5 only: `$state`, `$derived`, `$effect`. Never use `$:`, `let x = writable()`, or Svelte 4 patterns.
- Server-side code must go in `src/lib/server/` or `+page.server.ts` / `+server.ts` to respect the Workers boundary.
- If you discover missing test infrastructure (fixtures, mocks, helpers), set that up first.
- Commit after each green phase if the change is meaningful.
- If Chrome is available, always visually verify UI changes before reporting completion.

## Task

$ARGUMENTS
