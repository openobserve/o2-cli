# O2 CLI - Upgrade Guide

Complete guide for upgrading O2 CLI to the latest version.

---

## 📦 Upgrade Methods

### Method 1: Homebrew (Recommended)

#### **Standard Upgrade**
```bash
# Update Homebrew
brew update

# Upgrade O2
brew upgrade o2

# Verify version
o2 --version
```

#### **Force Upgrade**
Use when stuck on an old version:
```bash
# Clear Homebrew cache
brew cleanup

# Reinstall
brew reinstall o2

# Verify
o2 --version
```

#### **Complete Refresh**
Nuclear option - completely removes and reinstalls:
```bash
# Remove old installation
brew uninstall o2

# Refresh tap
brew untap openobserve/tap
brew tap openobserve/tap

# Install latest
brew install o2

# Verify
o2 --version
```

---

### Method 2: Install Script

**Automatic Upgrade:**
```bash
# Re-run install script (detects and upgrades existing installation)
curl -fsSL https://raw.githubusercontent.com/openobserve/o2-cli/main/install.sh | bash
```

**The script will:**
- Detect existing installation
- Download latest release
- Backup old binary (optional)
- Replace with new version
- Preserve your config at `~/.o2/config.yaml`

---

### Method 3: Manual Download

**Step-by-step upgrade:**

```bash
# 1. Check latest version
VERSION=v1.1.3  # Replace with desired version

# 2. Determine your platform
# darwin-arm64   = macOS Apple Silicon (M1/M2/M3)
# darwin-amd64   = macOS Intel
# linux-amd64    = Linux x86_64
# linux-arm64    = Linux ARM64
# windows-amd64  = Windows 64-bit
PLATFORM=darwin-arm64

# 3. Download
curl -L "https://github.com/openobserve/o2-cli/releases/download/${VERSION}/o2-${PLATFORM}.tar.gz" -o o2.tar.gz

# 4. Extract
tar -xzf o2.tar.gz

# 5. Backup old binary (optional)
sudo mv /usr/local/bin/o2 /usr/local/bin/o2.backup 2>/dev/null || true

# 6. Install new version
sudo mv o2 /usr/local/bin/o2

# 7. Make executable
sudo chmod +x /usr/local/bin/o2

# 8. Verify
o2 --version

# 9. Cleanup
rm o2.tar.gz README.md COMMANDS.md
```

---

### Method 4: Go Install

**For Go developers:**

```bash
# Install/upgrade to latest from source
go install github.com/openobserve/o2-operator/cmd/cli@latest

# Verify (binary in $GOPATH/bin, usually ~/go/bin)
~/go/bin/o2 --version

# Add to PATH if needed
export PATH="$HOME/go/bin:$PATH"
```

---

## 🔍 Verify Upgrade

### Check Version
```bash
o2 --version
```

**Expected output:**
```
o2 version 1.1.3
```

### Verify Configuration Preserved
```bash
# List profiles (should show your existing profiles)
o2 configure list

# Test connection
o2 list organizations
```

### Run Health Check
```bash
# Test core commands
o2 --help
o2 list organizations
o2 configure list
```

---

## 📋 Upgrade Checklist

Before upgrading:
- [ ] Backup config: `cp ~/.o2/config.yaml ~/.o2/config.yaml.backup`
- [ ] Note current version: `o2 --version`
- [ ] Check latest version: https://github.com/openobserve/o2-cli/releases

During upgrade:
- [ ] Run upgrade command
- [ ] Wait for completion
- [ ] No errors displayed

After upgrade:
- [ ] Verify new version: `o2 --version`
- [ ] Config intact: `o2 configure list`
- [ ] Test connection: `o2 list organizations`
- [ ] All commands work: `o2 --help`

---

## 🔄 Downgrade / Rollback

### Homebrew
```bash
# Not directly supported, use manual method
```

### Manual Rollback
```bash
# Download specific version
VERSION=v1.1.2
PLATFORM=darwin-arm64

curl -L "https://github.com/openobserve/o2-cli/releases/download/${VERSION}/o2-${PLATFORM}.tar.gz" | tar xz
sudo mv o2 /usr/local/bin/o2
sudo chmod +x /usr/local/bin/o2

# Verify
o2 --version
```

### From Backup (if you backed up)
```bash
# Restore old binary
sudo mv /usr/local/bin/o2.backup /usr/local/bin/o2

# Verify
o2 --version
```

---

## 📅 Update Schedule

### Recommended Update Frequency

**Production environments:**
- Check for updates monthly
- Apply after testing in dev/staging
- Review release notes before upgrading

**Development environments:**
- Update weekly or on each release
- Test new features immediately

**Check for updates:**
```bash
# View latest release
gh release view --repo openobserve/o2-cli

# Or visit
https://github.com/openobserve/o2-cli/releases
```

---

## 🔔 Release Notifications

### Subscribe to Releases

**GitHub:**
1. Go to https://github.com/openobserve/o2-cli
2. Click "Watch" → "Custom" → "Releases"
3. Get notified on new releases

**RSS Feed:**
```
https://github.com/openobserve/o2-cli/releases.atom
```

---

## 🚀 Best Practices

### 1. Test Before Production
```bash
# Test upgrade in dev first
o2 configure --profile dev
o2 list organizations --profile dev

# If works, upgrade production
o2 list organizations --profile prod
```

### 2. Backup Config
```bash
# Before major version upgrades
cp ~/.o2/config.yaml ~/.o2/config.yaml.$(date +%Y%m%d)
```

### 3. Pin Versions in CI/CD
```bash
# In CI scripts, use specific version
VERSION=v1.1.3
curl -L "https://github.com/openobserve/o2-cli/releases/download/${VERSION}/o2-linux-amd64.tar.gz" | tar xz
chmod +x o2
./o2 --version
```

### 4. Keep Homebrew Updated
```bash
# Regular maintenance
brew update
brew upgrade
brew cleanup
```

---

## 📚 Related Documentation

- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Issue resolution
- [README.md](../README.md) - Getting started
- [COMMANDS.md](COMMANDS.md) - Command reference

---

## 🆕 What's New

### v1.1.3
- Fixed version display to show actual release version
- Added organization management (create, get, summary)
- Enhanced alert CRUD operations
- Improved YAML parsing for complex types

### v1.1.2
- Full alert CRUD support
- GoReleaser automation
- Homebrew formula auto-updates

### v1.1.1
- Initial stable release
- Core resource management
- Multi-profile support

**For full changelog:** https://github.com/openobserve/o2-cli/releases

---

**Last Updated:** 2026-01-17
**Current Stable Version:** v1.1.3
**Upgrade from:** Any version → v1.1.3
