# Colima + Docker

Colima provides the Docker runtime without Docker Desktop. Lightweight, CLI-native.

## Setup

```bash
colima start                    # start the VM
colima start --cpu 4 --memory 8 # with specific resources
```

## Aliases

```bash
dc      # docker compose
dcu     # docker compose up -d
dcd     # docker compose down
dcl     # docker compose logs -f
dps     # pretty docker ps
```

## When to use Docker

Cloudflare Workers handles most compute, but you need containers for:
- **Local Postgres** -- when D1 isn't the right fit
- **Redis** -- for caching/queues during development
- **Third-party services** -- anything you need to simulate locally

## Example: Postgres for local dev

```yaml
# docker-compose.yml
services:
  postgres:
    image: postgres:16-alpine
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

```bash
dcu              # start
dcl              # tail logs
dcd              # stop and remove
```

## Cleanup

```bash
docker system prune -f           # remove stopped containers, unused networks
docker volume prune -f           # remove unused volumes
docker image prune -a -f         # remove all unused images
```
