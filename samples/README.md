# O2 CLI Samples

Sample YAML files for use with O2 CLI commands.

## 📂 Directory Structure

```
samples/
├── templates/      # Alert template samples (6 files)
├── destinations/   # Destination samples (3 files)
├── pipelines/      # Pipeline samples (2 files)
├── functions/      # Function samples (5 files)
├── dashboards/     # Dashboard samples (2 files)
└── alerts/         # Alert samples (2 files)
```

## 📋 Available Samples by Resource

### Templates (6 samples)
Alert notification templates for HTTP, Email, Slack.

**Simple format** (recommended for CLI):
- `simple-http-template.yaml`
- `simple-slack-template.yaml`
- `simple-email-template.yaml`

**Full K8s format**:
- `http-alert-template.yaml`
- `email-html-alert-template.yaml`
- `http-slack-webhook-template.yaml`

**Usage:**
```bash
o2 create template -f templates/simple-http-template.yaml
```

---

### Destinations (3 samples)
HTTP, Email, and Pipeline destinations.

- `simple-http-alert-destination.yaml`
- `simple-email-destination.yaml`
- `simple-pipeline-destination.yaml`

**Usage:**
```bash
o2 create dest -f destinations/simple-http-alert-destination.yaml
```

---

### Pipelines (2 samples)
Data processing pipelines.

- `real-time-pipeline1.yaml`
- Plus operator samples

**Usage:**
```bash
o2 create pipeline -f pipelines/real-time-pipeline1.yaml
```

---

### Functions (5 samples)
VRL transformation functions.

- `simple-add-field.yaml`
- `simple-parse-json.yaml`
- `simple-geoip-enrichment.yaml`
- `simple-filter-sensitive.yaml`
- `basic-function.yaml`

**Usage:**
```bash
o2 create function -f functions/simple-add-field.yaml
```

---

### Dashboards (2 samples)
Dashboard configurations.

- `dashboard1.yaml` - Simple multi-tab dashboard
- `dashboard4.yaml` - Comprehensive dashboard with all chart types

**Usage:**
```bash
o2 create dashboard -f dashboards/dashboard1.yaml
```

**Note:** Dashboards use full K8s YAML format.

---

### Alerts (2 samples)
Alert configurations.

- `real-time-logs-alert.yaml` - Real-time alert
- `scheduled-sql-logs-alert.yaml` - Scheduled SQL alert

**Usage:**
```bash
# Currently view-only (create coming soon)
cat alerts/real-time-logs-alert.yaml

# Use operator to create
kubectl apply -f alerts/real-time-logs-alert.yaml

# Then query with CLI
o2 list alert
```

---

## 🎯 Quick Start

```bash
# Navigate to samples
cd o2-cli/samples

# Create a template
o2 create template -f templates/simple-http-template.yaml

# Create a destination
o2 create dest -f destinations/simple-http-alert-destination.yaml

# Create a function
o2 create function -f functions/simple-add-field.yaml

# Create a dashboard
o2 create dashboard -f dashboards/dashboard1.yaml
```

---

## 📝 YAML Formats

### Simple Format (Templates, Destinations, Functions)
Just the resource fields - no K8s wrapper:
```yaml
name: "resource-name"
# resource-specific fields
```

### Full K8s Format (Dashboards, Pipelines, Alerts)
Complete Kubernetes resource:
```yaml
apiVersion: openobserve.ai/v1alpha1
kind: OpenObserve<Resource>
metadata:
  name: resource-name
spec:
  # resource configuration
```

**Both formats work!** CLI auto-detects.

---

## 🔗 More Information

- [Main CLI Guide](../README.md)
- [Command Reference](../COMMANDS.md)
- [Operator Samples](../../o2-k8s-operator/samples/) - More examples
