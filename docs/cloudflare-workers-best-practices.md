# Cloudflare Workers Best Practices

Production patterns, internal Cloudflare usage, and common pitfalls.

## Configuration

### Keep compatibility_date current
Set to today's date on new projects. Update periodically on existing ones for new APIs and fixes.

### Enable nodejs_compat
Add `"nodejs_compat"` to `compatibility_flags`. Required for `node:crypto`, `node:buffer`, `node:stream`, and most npm libraries.

### Generate binding types
Run `wrangler types` instead of hand-writing `Env`. Re-run whenever bindings change. Catches config/code mismatches at compile time.

### Secrets management
Use `wrangler secret put` for API keys/tokens — never put secrets in `wrangler.jsonc` or source. Use `.env` for local dev (add to `.gitignore`). Non-secret config goes in `vars`.

### Environments
Root config = shared base. Each `env.{name}` override deploys as `{name}-{env}` (e.g., `my-api-production`). Deploy with `wrangler deploy --env production`.

### Routing
- **Custom domains**: Worker is the origin. DNS/SSL automatic.
- **Routes**: Worker in front of existing origin. Requires a proxied DNS record — missing it causes `ERR_NAME_NOT_RESOLVED`. Use a proxied `AAAA` record pointing to `100::` as placeholder if no real origin.

## Request & Response Handling

### Stream bodies
Don't `await response.text()` or `await request.arrayBuffer()` on large payloads (128 MB memory limit). Stream through with `new Response(response.body, response)`. For concatenating multiple responses, use `pipeTo(writable, { preventClose: true })` sequentially.

### Use waitUntil for post-response work
`ctx.waitUntil()` for analytics, cache writes, logging after the response is sent. Don't destructure `ctx` (loses `this` binding → "Illegal invocation"). 30-second time limit after response.

## Architecture

### Bindings over REST APIs
Use bindings (R2, KV, D1, Queues, Workflows) — direct in-process references with no network hop, no auth, no extra latency. Never call the Cloudflare REST API from inside a Worker.

### Queues vs Workflows
- **Queues**: Decouple producer/consumer. Fan-out, buffering/batching, single-step background jobs. At-least-once delivery.
- **Workflows**: Multi-step durable execution. Each step persisted, only failed steps retry. Can pause for hours/days (`step.waitForEvent()`).
- **Both together**: Queue buffers high-throughput entry, consumer creates Workflow per item.

### Service bindings for Worker-to-Worker
Zero-cost, bypass public internet, support type-safe RPC via `WorkerEntrypoint`.

### Hyperdrive for external databases
Always use Hyperdrive for remote PostgreSQL/MySQL. Maintains regional connection pool — eliminates per-request TCP+TLS+auth cost (300-500ms). Create a new `Client` per request (Hyperdrive pools underneath). Requires `nodejs_compat`.

### Durable Objects for WebSockets
Use Durable Objects with Hibernation API for reliable, long-lived WebSocket connections. Use `this.ctx.acceptWebSocket()` (not `ws.accept()`) for hibernation. Use `setWebSocketAutoResponse` for ping/pong without waking the object.

### Workers Static Assets for new projects
Recommended over Pages for new static sites, SPAs, and full-stack apps. Point `assets.directory` at build output. Add `main` entry point + `ASSETS` binding for full-stack.

## Observability

### Enable logs and traces
Set `observability.enabled: true` in wrangler config. Use `head_sampling_rate` to control volume. Use structured JSON with `console.log(JSON.stringify({...}))`. Use `console.error` for errors (correct severity in dashboard).

## Code Patterns

### No request-scoped state in global scope
Worker isolates are reused across requests. Global mutable variables leak data between requests and cause "Cannot perform I/O on behalf of a different request" errors. Pass state through function arguments.

### Always await or waitUntil promises
Floating promises = silent bugs, dropped results, swallowed errors. The runtime may terminate before completion. Lint with `@typescript-eslint/no-floating-promises` or `oxlint typescript/no-floating-promises`.

## Security

### Web Crypto for tokens
Use `crypto.randomUUID()` and `crypto.getRandomValues()` — never `Math.random()` for security. Use `crypto.subtle.timingSafeEqual()` for secret comparison (hash both values to fixed size first to avoid leaking length).

### No passThroughOnException
It hides bugs by silently falling through to origin. Use explicit `try/catch` with structured error responses instead.

## Testing

### @cloudflare/vitest-pool-workers
Runs tests inside the Workers runtime with real bindings (KV, R2, D1, DO). Catches issues Node.js tests miss. Pitfall: the pool auto-injects `nodejs_compat`, so tests pass even without the flag in your config — always confirm it's in `wrangler.jsonc`.
