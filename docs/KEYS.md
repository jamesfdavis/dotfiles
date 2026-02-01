# SSH Key Management Guide

This document explains the SSH key strategy used in this dotfiles setup.

## Key Overview

After running `install.sh`, you will have **two separate SSH keys**:

| Key | Location | Purpose | Registered on GitHub as |
|-----|----------|---------|-------------------------|
| **Authentication** | `~/.ssh/id_ed25519` | Push/pull to GitHub | "Authentication Key" |
| **Signing** | `~/.ssh/id_ed25519_signing` | Sign commits & tags | "Signing Key" |

## Why Two Keys?

**Separation of concerns:**
- If your auth key is compromised, your commit history remains verified
- If you rotate your signing key, you don't lose SSH access
- Different expiration/rotation schedules if needed

**Practical benefit:** You can revoke one without affecting the other.

## File Inventory

After setup, your `~/.ssh/` directory should contain:

```
~/.ssh/
├── id_ed25519              # Auth private key (NEVER SHARE)
├── id_ed25519.pub          # Auth public key → GitHub "Authentication Key"
├── id_ed25519_signing      # Signing private key (NEVER SHARE)
├── id_ed25519_signing.pub  # Signing public key → GitHub "Signing Key"
├── config                  # SSH client configuration
└── known_hosts             # Verified host fingerprints
```

## GitHub Registration

Both public keys must be registered on GitHub, but as **different types**:

### Step 1: Add Authentication Key
1. Go to: GitHub → Settings → SSH and GPG keys
2. Click "New SSH key"
3. Title: `MacBook Pro 2026 - Auth`
4. Key type: **Authentication Key** ← Important!
5. Paste contents of `~/.ssh/id_ed25519.pub`

### Step 2: Add Signing Key
1. Click "New SSH key" again
2. Title: `MacBook Pro 2026 - Signing`
3. Key type: **Signing Key** ← Important!
4. Paste contents of `~/.ssh/id_ed25519_signing.pub`

## Verification

### Test Authentication
```bash
ssh -T git@github.com
# Expected: "Hi jamesfdavis! You've successfully authenticated..."
```

### Test Signing
```bash
# Make a test commit
echo "test" >> test.txt
git add test.txt
git commit -m "Test signed commit"

# Verify it was signed
git log --show-signature -1
# Should show: "Good signature from..."
```

### Check GitHub Badge
Push the commit to GitHub. You should see a green "Verified" badge next to it.

## How Git Knows Which Key to Use

The `.gitconfig` contains:

```ini
[gpg]
    format = ssh

[user]
    signingkey = ~/.ssh/id_ed25519_signing.pub

[commit]
    gpgsign = true

[tag]
    gpgsign = true
```

This tells Git:
1. Use SSH format for signing (not GPG)
2. Use the dedicated signing key
3. Auto-sign all commits and tags

## Troubleshooting

### "error: Load key ... Permission denied"
```bash
chmod 600 ~/.ssh/id_ed25519_signing
chmod 644 ~/.ssh/id_ed25519_signing.pub
```

### Commits not showing as "Verified" on GitHub
1. Confirm the signing key is uploaded as a **Signing Key** (not Auth)
2. Confirm your Git email matches a verified email on GitHub:
   ```bash
   git config --global user.email
   # Must match an email in GitHub → Settings → Emails
   ```

### "gpg failed to sign the data"
This usually means Git is trying to use GPG instead of SSH. Verify:
```bash
git config --global gpg.format
# Should output: ssh
```

### Want to sign a specific commit manually?
```bash
git commit -S -m "Explicitly signed commit"
```

### Want to NOT sign a specific commit?
```bash
git commit --no-gpg-sign -m "Unsigned commit"
```

## Key Rotation

When you get a new machine or need to rotate keys:

1. Generate new keys (run `./scripts/setup-ssh-signing.sh`)
2. Add new keys to GitHub (don't remove old ones yet)
3. Test auth and signing work
4. Remove old keys from GitHub
5. Delete old keys from `~/.ssh/` (optional, but tidy)

Old commits signed with the old key will still show as "Verified" on GitHub.

## Backup Strategy

**Do backup:**
- `~/.ssh/id_ed25519` (auth private key)
- `~/.ssh/id_ed25519_signing` (signing private key)

**Store in:** 1Password, Bitwarden, or encrypted USB drive

**Do NOT:**
- Commit private keys to any repository
- Store in plain text in cloud storage
- Email them to yourself

## Quick Reference Commands

```bash
# List your keys
ls -la ~/.ssh/

# View a public key (safe to share)
cat ~/.ssh/id_ed25519_signing.pub

# Test GitHub auth
ssh -T git@github.com

# Check Git signing config
git config --global --get gpg.format
git config --global --get user.signingkey
git config --global --get commit.gpgsign

# Verify last commit signature
git log --show-signature -1
```

## Related Files in This Repo

- `scripts/setup-ssh-signing.sh` — Generates the signing key and configures Git
- `.gitconfig` — Contains signing configuration
- `~/.extra` — Store your Git credentials here (not committed)
