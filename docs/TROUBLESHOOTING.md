# O2 CLI - Troubleshooting Guide

Common issues and their solutions for O2 CLI.

---

## 🐛 Common Issues

### Issue 1: Version Shows Wrong Number

**Symptoms:**
```bash
o2 --version
# Output: o2 version 1.0.0
# Expected: o2 version 1.1.3
```

**Cause:**
- Old cached binary
- Homebrew cache not cleared
- Multiple installations

**Solutions:**

**Quick Fix:**
```bash
brew cleanup
brew reinstall o2
o2 --version
```

**Complete Fix:**
```bash
# Find all o2 binaries
which -a o2

# Remove all
sudo rm /usr/local/bin/o2
sudo rm /usr/bin/o2
rm ~/go/bin/o2

# Clear shell cache
hash -r

# Reinstall
brew install o2

# Verify
which o2
o2 --version
```

---

### Issue 2: Command Not Found

**Symptoms:**
```bash
o2 --version
# -bash: o2: command not found
```

**Causes:**
1. Binary not in PATH
2. Installation incomplete
3. Shell not refreshed

**Solutions:**

**Check installation:**
```bash
# For Homebrew
brew list o2

# Find binary location
which o2

# If not found, check Homebrew bin
ls /opt/homebrew/bin/o2  # Apple Silicon
ls /usr/local/bin/o2     # Intel Mac
```

**Fix PATH:**
```bash
# For zsh (macOS default)
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# For bash
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify
echo $PATH
```

**Reinstall:**
```bash
brew uninstall o2
brew install o2
hash -r
```

---

### Issue 3: No Formula with Name "o2"

**Symptoms:**
```bash
brew install o2
# Warning: No available formula with the name "o2"
```

**Causes:**
1. Tap not added
2. Formula not synced
3. Homebrew cache stale

**Solutions:**

**Step 1: Check tap**
```bash
brew tap | grep openobserve
# Should show: openobserve/tap
```

**Step 2: Add tap if missing**
```bash
brew tap openobserve/tap
```

**Step 3: Verify formula exists**
```bash
ls $(brew --repository)/Library/Taps/openobserve/homebrew-tap/Formula/
# Should show: o2.rb  zinc.rb  zincsearch.rb
```

**Step 4: If o2.rb missing, refresh tap**
```bash
brew untap openobserve/tap
brew tap openobserve/tap
brew update
```

**Step 5: Try full name**
```bash
brew install openobserve/tap/o2
```

---

### Issue 4: No Profile Configured

**Symptoms:**
```bash
o2 list organizations
# Error: failed to get profile: profile 'default' not found
```

**Cause:** CLI not configured

**Solution:**
```bash
# Configure default profile
o2 configure

# Enter when prompted:
# - OpenObserve Endpoint (e.g., https://api.openobserve.ai)
# - Organization name (e.g., default)
# - Username/Email
# - Password

# Verify config created
cat ~/.o2/config.yaml

# Test connection
o2 list organizations
```

**Configure multiple profiles:**
```bash
o2 configure --profile dev
o2 configure --profile prod

# List all profiles
o2 configure list
```

---

### Issue 5: Authentication Failed (401)

**Symptoms:**
```bash
o2 list dashboard
# Error: API error (status 401): Unauthorized
```

**Causes:**
1. Wrong credentials
2. Token expired
3. Wrong endpoint

**Solutions:**

**Reconfigure profile:**
```bash
o2 configure
# Re-enter credentials

# Or for specific profile
o2 configure --profile prod
```

**Check config:**
```bash
cat ~/.o2/config.yaml | grep -v password
# Verify:
# - Endpoint URL is correct
# - Organization name is correct
# - Username is correct
```

**Test with different org:**
```bash
o2 list organizations
# This should work even with wrong org in profile

# Then use correct org
o2 list dashboard --org correct-org-name
```

**Use token instead of password:**
```yaml
# Edit ~/.o2/config.yaml
profiles:
  default:
    endpoint: https://api.openobserve.ai
    organization: default
    username: your@email.com
    token: your-api-token  # Use token instead of password
    # password: ...
```

---

### Issue 6: SSL/TLS Certificate Errors

**Symptoms:**
```bash
o2 list dashboard
# Error: x509: certificate verification failed
```

**Causes:**
1. Self-signed certificate
2. Invalid certificate
3. System CA certificates outdated

**Solutions:**

**For Development/Testing (Skip TLS verification):**
```yaml
# Edit ~/.o2/config.yaml
profiles:
  dev:
    endpoint: https://dev.openobserve.local
    organization: default
    username: admin
    password: password
    tls_verify: false  # Add this line
```

**For Production (Fix certificates):**
```bash
# Update system CA certificates
# macOS:
sudo security verify-cert -c /path/to/cert.pem

# Linux:
sudo update-ca-certificates

# Use valid endpoint with proper SSL
o2 configure
# Enter: https://api.openobserve.ai (with valid cert)
```

---

### Issue 7: Resource Not Found

**Symptoms:**
```bash
o2 get template my-template
# Error: Template 'my-template' not found

o2 delete alert my-alert
# Error: Alert 'my-alert' not found
```

**Causes:**
1. Resource doesn't exist
2. Wrong organization
3. Typo in name

**Solutions:**

**List to find correct name:**
```bash
# List all templates
o2 list template

# List alerts
o2 list alert

# Use exact name from list output
o2 get template StandardAlert  # Use exact case
```

**Check organization:**
```bash
# List orgs you have access to
o2 list organizations

# Try different org
o2 get template my-template --org different-org
```

**Check with filters:**
```bash
# For alerts, check all folders
o2 list alert --folder default
o2 list alert --folder production
```

---

### Issue 8: API Error (400/500)

**Symptoms:**
```bash
o2 create alert -f alert.yaml
# Error: API error (status 400): Json deserialize error...
```

**Causes:**
1. Invalid YAML format
2. Missing required fields
3. Referenced resources don't exist (templates, destinations)

**Solutions:**

**Validate YAML:**
```bash
# Check YAML syntax
python3 -c "import yaml; yaml.safe_load(open('alert.yaml'))"

# Use sample files as reference
ls o2-cli/samples/
```

**Create dependencies first:**
```bash
# For alerts, create template first
o2 create template -f template.yaml

# Then create destination
o2 create destination -f destination.yaml

# Then create alert
o2 create alert -f alert.yaml
```

**Check required fields:**
- Alerts: `name`, `streamName`, `streamType`, `destinations`, `queryCondition`, `triggerCondition`
- Dashboards: `title`, `dashboard` data
- Templates: `name`, `body`, `type`

---

### Issue 9: Permission Denied (File System)

**Symptoms:**
```bash
sudo mv o2 /usr/local/bin/o2
# Permission denied
```

**Solutions:**
```bash
# Create directory if missing
sudo mkdir -p /usr/local/bin

# Set permissions
sudo chown -R $(whoami) /usr/local/bin

# Then install
mv o2 /usr/local/bin/o2
chmod +x /usr/local/bin/o2
```

**Or use user directory:**
```bash
# Install in home directory
mkdir -p ~/bin
mv o2 ~/bin/o2
chmod +x ~/bin/o2

# Add to PATH
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

---

### Issue 10: Multiple Versions Installed

**Symptoms:**
```bash
which -a o2
# /opt/homebrew/bin/o2
# /usr/local/bin/o2
# /Users/you/go/bin/o2

o2 --version
# Shows different version than expected
```

**Solution:**
```bash
# Remove all installations
sudo rm /usr/local/bin/o2 2>/dev/null || true
sudo rm /usr/bin/o2 2>/dev/null || true
rm ~/go/bin/o2 2>/dev/null || true

# Uninstall Homebrew version
brew uninstall o2 2>/dev/null || true

# Clear shell hash
hash -r

# Reinstall via Homebrew only
brew install o2

# Verify single installation
which o2
# Should show only: /opt/homebrew/bin/o2 (or /usr/local/bin/o2)

o2 --version
```

---

### Issue 11: Config File Corruption

**Symptoms:**
```bash
o2 list organizations
# Error: yaml: unmarshal error
```

**Solution:**
```bash
# Backup broken config
mv ~/.o2/config.yaml ~/.o2/config.yaml.broken

# Reconfigure
o2 configure

# If you have a backup, restore it
mv ~/.o2/config.yaml.backup ~/.o2/config.yaml

# Verify
cat ~/.o2/config.yaml
```

**Valid config format:**
```yaml
profiles:
  default:
    endpoint: https://api.openobserve.ai
    organization: default
    username: user@example.com
    password: your-password
    tls_verify: true
```

---

### Issue 12: Homebrew Formula Out of Date

**Symptoms:**
```bash
brew info o2
# openobserve/tap/o2: stable 1.1.2

# But GitHub shows v1.1.3 available
```

**Solutions:**

**Force update tap:**
```bash
brew update --force
brew upgrade o2
```

**Manual tap refresh:**
```bash
cd $(brew --repository)/Library/Taps/openobserve/homebrew-tap
git pull origin main
cd -
brew upgrade o2
```

**Complete refresh:**
```bash
brew untap openobserve/tap
brew tap openobserve/tap
brew install o2
```

---

## 🔧 Diagnostic Commands

### System Information
```bash
# Platform
uname -m
# arm64 = Apple Silicon
# x86_64 = Intel/AMD

# OS
uname -s
# Darwin = macOS
# Linux = Linux

# Homebrew version
brew --version

# Shell
echo $SHELL
```

### Installation Info
```bash
# Binary location
which o2

# File details
ls -l $(which o2)
file $(which o2)

# Homebrew info
brew list o2
brew info o2

# Tap info
brew tap-info openobserve/tap
```

### Config Verification
```bash
# Config location
ls -la ~/.o2/

# Config contents (hide password)
cat ~/.o2/config.yaml | sed 's/password:.*/password: ***/'

# Test config
o2 configure list
```

### Connection Test
```bash
# Test basic connectivity
o2 list organizations

# Test with verbose errors
o2 list dashboard 2>&1

# Test specific profile
o2 list organizations --profile prod
```

---

## 🆘 Getting Help

### Gather Information

Before reporting an issue, collect:

**1. Version:**
```bash
o2 --version
```

**2. Installation method:**
- [ ] Homebrew
- [ ] Install script
- [ ] Manual download
- [ ] Go install

**3. Platform:**
```bash
uname -a
```

**4. Error output:**
```bash
# Run failing command with full output
o2 list dashboard 2>&1 | tee error.log
```

**5. Config (redact passwords!):**
```bash
cat ~/.o2/config.yaml | grep -v password | grep -v token
```

### Report Issue

**GitHub Issues:** https://github.com/openobserve/o2-cli/issues

**Include:**
- Output from commands above
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

---

## 🔍 Debug Mode

### Enable Verbose Output

Currently not implemented, but planned:
```bash
# Future feature
o2 --debug list dashboard
o2 --verbose create alert -f alert.yaml
```

---

## ✅ Health Check Script

**Quick diagnostic:**
```bash
#!/bin/bash
echo "=== O2 CLI Health Check ==="
echo ""
echo "Version:"
o2 --version
echo ""
echo "Installation:"
which o2
ls -l $(which o2)
echo ""
echo "Config:"
ls -la ~/.o2/
echo ""
echo "Profiles:"
o2 configure list
echo ""
echo "Connectivity:"
o2 list organizations
echo ""
echo "=== Health Check Complete ==="
```

---

## 📚 Related Documentation

- [UPGRADE.md](UPGRADE.md) - Upgrade procedures
- [README.md](../README.md) - Getting started
- [COMMANDS.md](COMMANDS.md) - Command reference

---

**Last Updated:** 2026-01-17
**Version:** 1.1.3
