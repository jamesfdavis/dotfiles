# Verify: Browser-Based UI Verification

Use Chrome to visually verify and test the current implementation. Requires `claude --chrome`.

## Process

1. **Start the dev server** — Run `pnpm dev` if not already running. Note the local URL (usually `http://localhost:5173`).

2. **Visual check** — Navigate to each affected page and verify:
   - Layout matches the design intent (spacing, alignment, hierarchy)
   - Responsive behavior at mobile (375px), tablet (768px), and desktop (1280px) widths
   - Colors, typography, and contrast are correct
   - Loading states and skeleton screens appear appropriately
   - Empty states render when no data is present

3. **Interaction check** — Test all interactive elements:
   - Buttons, links, and form controls respond to click/tap
   - Form validation shows errors and success states
   - Transitions and animations are smooth (no layout shifts)
   - Keyboard navigation works (Tab, Enter, Escape)
   - Focus states are visible

4. **Console check** — Open the browser console and look for:
   - JavaScript errors or unhandled promise rejections
   - Svelte warnings (reactivity issues, missing props)
   - Network errors (failed API calls, 404s)
   - Deprecation warnings

5. **PWA check** — If service worker or caching changed:
   - Verify the app loads offline (disconnect network, reload)
   - Check that the manifest is valid (Application tab in DevTools)
   - Confirm install prompt appears on mobile

6. **Report findings** — Summarize what was verified and any issues found:
   - If issues exist: fix them immediately, then re-verify
   - If clean: report the verification as complete with what was tested

## Rules

- This command requires Chrome access (`claude --chrome`). If not available, suggest running `pnpm test:e2e` with Playwright instead.
- Do not skip the console check — runtime errors that tests miss often surface here.
- Always test at mobile width first. Most users interact with PWAs on phones.
- Take note of cumulative layout shift (CLS) — elements jumping on load indicates a performance problem.
- If the implementation changes during verification, re-run affected tests before committing.

## Scope

$ARGUMENTS
