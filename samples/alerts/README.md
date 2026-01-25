# O2 CLI - Alert Samples

Sample alert configurations for O2 CLI.

## 📋 Available Samples

### 1. real-time-logs-alert.yaml
Real-time alert monitoring log streams.

**Usage:**
```bash
o2 create alert -f real-time-logs-alert.yaml
```

### 2. scheduled-sql-logs-alert.yaml
Scheduled SQL-based alert.

**Usage:**
```bash
o2 create alert -f scheduled-sql-logs-alert.yaml
```

## 💡 Alert Commands

### List Alerts
```bash
# List all alerts
o2 list alert
o2 alert list

# Filter by folder
o2 list alert --folder ProductionAlerts
o2 list alert --folder default

# Show only enabled alerts
o2 list alert --enabled-only
o2 list alert --folder ProductionAlerts --enabled-only

# Different output formats
o2 list alert --output json
o2 list alert --output yaml
o2 list alert --output wide
```

### Get Alert Details
```bash
# Get specific alert by name
o2 get alert my-alert
o2 alert get my-alert

# Export to YAML
o2 get alert my-alert --output yaml
```

### Create Alert
```bash
# Create from file
o2 create alert -f real-time-logs-alert.yaml
o2 alert create -f scheduled-sql-logs-alert.yaml
```

### Update Alert
```bash
# Update from file (auto-extracts name)
o2 update alert -f alert.yaml
o2 alert update -f alert.yaml

# Update with explicit name
o2 update alert my-alert -f updated-alert.yaml
```

### Delete Alert
```bash
# Delete by name
o2 delete alert my-alert
o2 alert delete my-alert

# Delete from file (extracts name from file)
o2 delete alert -f alert.yaml
```

### Enable/Disable Alert
```bash
# Enable an alert
o2 alert enable my-alert

# Disable an alert
o2 alert disable my-alert
```

## 🎯 Complete Workflow Example

```bash
# 1. Create an alert
o2 create alert -f real-time-logs-alert.yaml

# 2. List to verify
o2 list alert --folder default

# 3. Get details
o2 get alert real-time-logs-alert

# 4. Disable temporarily
o2 alert disable real-time-logs-alert

# 5. Re-enable
o2 alert enable real-time-logs-alert

# 6. Update configuration
o2 update alert -f real-time-logs-alert.yaml

# 7. Delete when done
o2 delete alert real-time-logs-alert
```

## 🔗 More Information

See [COMMANDS.md](../../docs/COMMANDS.md) for complete command reference.
