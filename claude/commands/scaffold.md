# Scaffold: SvelteKit PWA on Cloudflare

Generate a new SvelteKit PWA project with Cloudflare Workers, fully wired.

## Process

1. **Create the project** — Run the following in the target directory:
   ```bash
   pnpm create svelte@latest $PROJECT_NAME -- --template skeleton --types typescript
   cd $PROJECT_NAME
   ```

2. **Install core dependencies**:
   ```bash
   pnpm add -D @sveltejs/adapter-cloudflare
   pnpm add -D vitest @testing-library/svelte @testing-library/jest-dom jsdom
   pnpm add -D @playwright/test
   pnpm add -D vite-plugin-pwa @vite-pwa/sveltekit workbox-precaching
   pnpm add -D tailwindcss @tailwindcss/vite
   ```

3. **Configure adapter** — Update `svelte.config.js`:
   - Replace default adapter with `adapter-cloudflare`
   - Set `platform: 'browser'` for client-side PWA support

4. **Configure Tailwind CSS** — Add `@tailwindcss/vite` to `vite.config.ts`:
   ```typescript
   import tailwindcss from '@tailwindcss/vite';

   export default defineConfig({
     plugins: [tailwindcss(), sveltekit(), SvelteKitPWA(/* ... */)],
   });
   ```
   Then set `src/app.css` as the global stylesheet:
   ```css
   @import 'tailwindcss';
   ```
   Import `app.css` in `src/routes/+layout.svelte`:
   ```svelte
   <script>
     import '../app.css';
     let { children } = $props();
   </script>
   ```

5. **Wire Cloudflare bindings** — Create `wrangler.toml`:
   ```toml
   name = "$PROJECT_NAME"
   compatibility_date = "2025-01-01"
   pages_build_output_dir = ".svelte-kit/cloudflare"

   [[d1_databases]]
   binding = "DB"
   database_name = "$PROJECT_NAME-db"
   database_id = "<create-with-wrangler>"

   [vars]
   ENVIRONMENT = "development"
   ```

6. **Set up PWA manifest** — Create `static/manifest.json`:
   - App name, short name, theme color, background color
   - Icons at 192x192 and 512x512
   - `display: standalone`, `start_url: /`

7. **Configure testing layers**:
   - `vitest.config.ts` — Unit tests for logic (lib/, utils/)
   - `vitest.config.ts` — Component tests with jsdom + testing-library
   - `playwright.config.ts` — E2E tests against `pnpm preview`
   - Add scripts to `package.json`:
     ```json
     "test": "vitest run",
     "test:watch": "vitest",
     "test:e2e": "playwright test",
     "test:all": "vitest run && playwright test"
     ```

8. **Create project structure**:
   ```
   src/
   ├── lib/
   │   ├── components/     # Reusable Svelte components
   │   ├── server/         # Server-only (Cloudflare Workers)
   │   │   └── db.ts       # D1 helpers
   │   ├── stores/         # Svelte 5 runes-based state
   │   └── utils/          # Pure functions, shared types
   ├── routes/
   │   ├── +layout.svelte  # Root layout with PWA meta
   │   ├── +page.svelte    # Home page
   │   └── api/            # API routes (Workers)
   ├── app.html            # Shell with PWA meta tags
   └── app.css             # Tailwind entry point (@import 'tailwindcss')
   tests/
   ├── unit/               # Vitest unit tests
   ├── component/          # Testing-library component tests
   └── e2e/                # Playwright E2E tests
   ```

9. **Generate project CLAUDE.md** — Copy and fill `project-CLAUDE.md.example` with the actual structure, commands, and conventions.

10. **Initialize git** — `git init`, initial commit, create GitHub repo with `gh repo create`.

11. **Verify** — Run `pnpm dev` and confirm the app loads. Run `pnpm test` and confirm the test harness works.

## Rules

- Always use `pnpm`, never `npm` or `yarn`.
- Use Svelte 5 runes (`$state`, `$derived`, `$effect`) — never legacy `$:` reactive statements.
- All server-side code goes in `src/lib/server/` to enforce the Workers boundary.
- D1 database ID is left as a placeholder — the developer runs `wrangler d1 create` separately.
- PWA icons are placeholders — remind the developer to replace them.

## Project Name

$ARGUMENTS
