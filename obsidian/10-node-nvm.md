# Node.js + NVM

## NVM (Node Version Manager)

NVM manages multiple Node.js versions. Installed via Homebrew, lazy-loaded in `.zshrc` so it doesn't slow down shell startup.

### How lazy loading works

NVM normally adds 200-400ms to shell startup. The dotfiles defer initialization until you first run `node`, `npm`, `npx`, or `nvm`. First invocation has a one-time delay; every call after is instant.

### Installing Node versions

```bash
nvm install --lts           # install latest LTS
nvm install 20              # install Node 20.x
nvm install 18              # install Node 18.x
nvm ls                      # list installed versions
nvm ls-remote --lts         # list available LTS versions
```

### Switching versions

```bash
nvm use 20                  # switch to Node 20
nvm use --lts               # switch to latest LTS
nvm alias default 20        # set default for new shells
```

### .nvmrc auto-switching

When you `cd` into a directory with a `.nvmrc` file, the shell automatically switches Node versions. No manual `nvm use` needed.

```bash
# In a project directory:
echo "20" > .nvmrc          # create .nvmrc
cd ../ && cd back/          # triggers auto-switch
node -v                     # confirms version 20.x
```

This is handled by the `_nvm_auto_use` hook in `.zshrc`. It also runs on shell startup if the current directory has a `.nvmrc`.

## npm aliases

```bash
ni          # npm install
nid         # npm install --save-dev
nr          # npm run <script>
nrd         # npm run dev
nrb         # npm run build
nrt         # npm run test
```

## Common workflows

### New Cloudflare Worker project

```bash
npm create cloudflare@latest my-worker
cd my-worker                # auto-switches to .nvmrc version if present
ni                          # install dependencies
nrd                         # start dev server
```

### Adding a dependency

```bash
ni express                  # production dependency
nid vitest                  # dev dependency
```

### Running scripts

```bash
nr                          # lists available scripts
nrd                         # npm run dev
nrb                         # npm run build
nrt                         # npm run test
```

## Global packages

Two packages are installed globally (via `install.sh`):

| Package | Purpose |
|---------|---------|
| `@anthropic-ai/claude-code` | Claude Code CLI |
| `wrangler` | Cloudflare Workers CLI |

Install or update globals:

```bash
npm install -g @anthropic-ai/claude-code
npm install -g wrangler
```

## Starship integration

When inside a directory with `package.json`, Starship shows the Node version in the prompt:

```
~/projects/my-worker  main  v20.11.0 >
```

Only appears in Node projects -- no noise elsewhere.
