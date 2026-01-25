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

## 💡 Dashboard Commands

### List Dashboards
```bash
# List all dashboards in default folder
o2 list dashboard
o2 dashboard list

# List dashboards in specific folder
o2 list dashboard --folder production
o2 list dashboard --folder o2cli

# Different output formats
o2 list dashboard --output json
o2 list dashboard --output yaml
o2 list dashboard --output wide
```

### Get Dashboard Details
```bash
# Get specific dashboard by ID
o2 get dashboard 7417863561566760960
o2 dashboard get 7417863561566760960

# Export to YAML
o2 get dashboard 7417863561566760960 --output yaml
```

### Create Dashboard
```bash
# Create from file (folder read from spec.folderName in YAML)
o2 create dashboard -f dashboard.yaml
o2 dashboard create -f dashboard.yaml

# The folder specified in spec.folderName will be auto-created if it doesn't exist
```

### Update Dashboard
```bash
# Update dashboard (requires ID + file)
o2 update dashboard 7417863561566760960 -f updated.yaml
o2 dashboard update 7417863561566760960 -f updated.yaml

# Folder is read from spec.folderName in the YAML file
```

### Delete Dashboard
```bash
# Delete by ID (uses default folder)
o2 delete dashboard 7417863561566760960
o2 dashboard delete 7417863561566760960

# Delete with specific folder
o2 delete dashboard 7417863561566760960 --folder production
```

## 📝 Important Notes

### Dashboard IDs
- Dashboards use **numeric IDs** (e.g., `7417863561566760960`)
- Get the ID from `o2 list dashboard` command
- Update and delete operations require the **dashboard ID**
- Get and list operations can filter by folder

### Folders
- Folder is specified in YAML: `spec.folderName: "production"`
- If folder doesn't exist, it will be **auto-created** during dashboard creation
- Default folder is `"default"` if not specified
- CLI shows: "Folder not present, creating new folder" when creating folders

### YAML Format
Dashboards use **full Kubernetes format** (includes apiVersion, kind, metadata, spec).

Example structure:
```yaml
apiVersion: openobserve.ai/v1alpha1
kind: OpenObserveDashboard
metadata:
  name: my-dashboard
  namespace: o2operator
spec:
  configRef:
    name: openobserve-config
    namespace: o2operator
  title: "My Dashboard"
  org: "default"
  folderName: "production"  # Auto-created if doesn't exist
  dashboard:
    # Dashboard definition here
```

### Workflow
```bash
# 1. Create dashboard (folder auto-created)
o2 create dashboard -f dashboard.yaml
# Output shows: "Folder not present, creating new folder" (if needed)

# 2. List to get ID
o2 list dashboard --folder production
# Shows: 7417863561566760960   My Dashboard

# 3. Get details
o2 get dashboard 7417863561566760960

# 4. Update (folder read from YAML)
o2 update dashboard 7417863561566760960 -f updated.yaml

# 5. Delete using ID
o2 delete dashboard 7417863561566760960 --folder production
```

## 🔗 More Information

- See [Operator Dashboard Samples](../../../o2-k8s-operator/samples/dashboards/) for more examples
- See [../README.md](../../README.md) for complete CLI guide
- See [../COMMANDS.md](../../COMMANDS.md) for detailed syntax
