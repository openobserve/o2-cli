# O2 CLI - Alert Samples

Sample alert configurations for O2 CLI.

## 📋 Available Samples

### 1. real-time-logs-alert.yaml
Real-time alert monitoring log streams.

**Usage:**
```bash
o2 create alert -f real-time-logs-alert.yaml
```

**Note:** Create operation coming soon. Currently use for reference.

### 2. scheduled-sql-logs-alert.yaml
Scheduled SQL-based alert.

**Usage:**
```bash
o2 create alert -f scheduled-sql-logs-alert.yaml
```

## 💡 Current Alert Operations

**✅ Working Now:**
```bash
# List alerts
o2 list alert
o2 list alert --folder ProductionAlerts
o2 list alert --enabled-only

# Get alert details
o2 get alert my-alert

# Different output formats
o2 list alert --output json
o2 list alert --output yaml
```

**⏳ Coming Soon:**
- Create alert
- Update alert
- Delete alert
- Enable/disable alert

## 🔗 More Information

For now, use the Kubernetes Operator for alert creation:
```bash
kubectl apply -f alert.yaml
```

Then manage with CLI:
```bash
o2 list alert
o2 get alert my-alert
```

See [Operator Alert Samples](../../../o2-k8s-operator/samples/alerts/) for more examples.
