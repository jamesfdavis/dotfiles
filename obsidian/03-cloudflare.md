# Cloudflare Workers

## Wrangler aliases

```bash
wr      # wrangler
wrd     # wrangler dev (local dev server on :8787)
wrdl    # wrangler dev --local (fully offline)
wrp     # wrangler deploy
wrl     # wrangler tail (live logs)
wrd1    # wrangler d1 (database operations)
wrkv    # wrangler kv (key-value store)
wrr2    # wrangler r2 (object storage)
wrpages # wrangler pages
wrsec   # wrangler secret (manage secrets)
```

## New Worker project

```bash
npm create cloudflare@latest my-worker
cd my-worker
cc  # let Claude Code take it from here
```

## Common patterns

### D1 (SQLite at the edge)
```bash
# Create a database
wrangler d1 create my-db

# Run migrations
wrangler d1 migrations apply my-db

# Query locally
wrangler d1 execute my-db --local --command "SELECT * FROM users"
```

### KV (Key-value)
```bash
# Create namespace
wrangler kv namespace create MY_KV

# Put/get values
wrangler kv key put --binding MY_KV "key" "value"
```

### R2 (Object storage)
```bash
# Create bucket
wrangler r2 bucket create my-bucket
```

## Local development

`wrangler dev` starts a local dev server that simulates the Workers runtime. It supports:
- Hot reloading
- Local D1 databases (SQLite)
- Local KV storage
- Local R2 buckets

For services that need real databases (Postgres, Redis), use [[04-docker|Colima + Docker]].

## Deploy

```bash
wrp  # wrangler deploy -- that's it
```

Wrangler reads `wrangler.toml` for configuration. Secrets are managed separately via `wrsec`.
