#!/bin/zsh

# Setup Local GPG Keys

# Hardened Configuration
`wget -O $GNUPGHOME/gpg.conf https://raw.githubusercontent.com/drduh/config/master/gpg.conf`
`chmod 600 gpg.conf`

# Generate Master Key
`gpg --expert --full-generate-key` #8 -> Certify Key
`gpg --list-secret-keys --keyid-format=long`

`export KEYID=0x`

# Master Key
`gpg --armor --export | pbcopy`

# SubKeys
`gpg --expert --edit-key $KEYID`

# Backup Keys
`gpg --armor --export-secret-keys $KEYID > $GNUPGHOME/mastersub.key`
`gpg --armor --export-secret-subkeys $KEYID > $GNUPGHOME/sub.key`

# Revocation Cert
`gpg --output $GNUPGHOME/revoke.asc --gen-revoke $KEYID`

# SSH Client
`wget -O $GNUPGHOME/gpg-agent.conf https://raw.githubusercontent.com/drduh/config/master/gpg-agent.conf`

# Increase default timeout
max-cache-ttl 28800
default-cache-ttl 28800

# Control SSH Agent
`gpg --with-keygrip -k $KEYID`
`touch ~/.gnupg/sshcontrol`

# https://github.com/drduh/YubiKey-Guide
# https://docs.github.com/en/github/authenticating-to-github/troubleshooting-ssh

# SSH Lockout

# Disable password based SSH authentication
`sudo vim /private/etc/ssh/sshd_config`

# PermitRootLogin no
# PasswordAuthentication no
# PermitEmptyPasswords no
# ChallengeResponseAuthentication no

# Docker Command over SSH
`security -v unlock-keychain ~/Library/Keychains/login.keychain-db`
