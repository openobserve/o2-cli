# O2 CLI - Dashboard Samples

Sample dashboard configurations for O2 CLI.

## 📋 Available Samples

### 1. dashboard1.yaml
Simple dashboard with multiple tabs.

**Usage:**
```bash
o2 create dashboard -f dashboard1.yaml
```

### 2. dashboard4.yaml
Comprehensive dashboard with multiple panel types.

**Usage:**
```bash
o2 create dashboard -f dashboard4.yaml
```

## 💡 Dashboard Operations

**All operations work with full K8s YAML format:**

```bash
# Create
o2 create dashboard -f dashboard.yaml
o2 dashboard create -f dashboard.yaml

# List
o2 list dashboard
o2 list dashboard --folder production

# Get (requires ID from list)
o2 get dashboard 7417863561566760960
o2 dashboard get 7417863561566760960 --output yaml

# Update (requires ID)
o2 update dashboard 7417863561566760960 -f updated.yaml

# Delete (requires ID from list)
o2 delete dashboard 7417863561566760960
o2 dashboard delete 7417863561566760960 --folder production
```

## 📝 Important Notes

### Dashboard IDs
- Dashboards use **numeric IDs** (e.g., `7417863561566760960`)
- Get the ID from `o2 list dashboard` command
- **Delete requires ID** (not file or title)

### Workflow
```bash
# 1. List to get ID
o2 list dashboard --folder production
# Shows: 7417863561566760960   My Dashboard

# 2. Delete using that ID
o2 delete dashboard 7417863561566760960
```

### YAML Format
Dashboards use **full Kubernetes format** (includes apiVersion, kind, metadata, spec).

The CLI auto-detects and handles the format correctly.

## 🔗 More Information

- See [Operator Dashboard Samples](../../../o2-k8s-operator/samples/dashboards/) for more examples
- See [../README.md](../../README.md) for complete CLI guide
- See [../COMMANDS.md](../../COMMANDS.md) for detailed syntax
