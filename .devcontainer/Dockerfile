FROM node:20

ARG CLAUDE_CODE_VERSION=latest

# System dependencies: dev tools + firewall utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    less git procps sudo fzf zsh man-db unzip gnupg2 gh \
    iptables ipset iproute2 dnsutils aggregate jq nano vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Persistent shell history across rebuilds
ARG USERNAME=node
RUN mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R $USERNAME /commandhistory

# npm global prefix — writable by the node user
RUN mkdir -p /usr/local/share/npm-global \
  && chown -R node:node /usr/local/share

ENV DEVCONTAINER=true
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin
ENV SHELL=/bin/zsh

# Workspace and Claude config directories
RUN mkdir -p /workspace /home/node/.claude \
  && chown -R node:node /workspace /home/node/.claude

WORKDIR /workspace
USER node

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}

# Firewall setup — runs as root via sudoers, called on container start
COPY init-firewall.sh /usr/local/bin/
USER root
RUN chmod +x /usr/local/bin/init-firewall.sh \
  && echo "node ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" \
       > /etc/sudoers.d/node-firewall \
  && chmod 0440 /etc/sudoers.d/node-firewall
USER node
