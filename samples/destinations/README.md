# O2 CLI - Destination Samples

Sample destination configurations for O2 CLI.

## 📋 Simple CLI Format

```yaml
name: "destination-name"              # Required
type: http                            # Required: http, email
url: "https://webhook.url"            # Required for http
method: post                          # Optional: post, put, get (default: post)
headers:                              # Optional
  Content-Type: "application/json"
template: "template-name"             # Optional: alert template name
skipTlsVerify: false                  # Optional: default false

# For email type:
emails:                               # Required if type: email
  - "user@company.com"

# For pipeline destinations:
destinationTypeName: splunk           # Optional: splunk, elasticsearch, etc.
```

## 📁 Available Samples

### Alert Destinations

**1. simple-http-alert-destination.yaml**
HTTP webhook for Slack/PagerDuty/Teams.

**Type:** Alert destination (http)

**Usage:**
```bash
o2 dest create -f simple-http-alert-destination.yaml
```

**2. simple-email-destination.yaml**
Email notification destination.

**Type:** Alert destination (email)

**Usage:**
```bash
o2 dest create -f simple-email-destination.yaml
```

### Pipeline Destinations

**3. simple-pipeline-destination.yaml**
Pipeline destination for Splunk/Elasticsearch.

**Type:** Pipeline destination (http with destinationTypeName)

**Usage:**
```bash
o2 dest create -f simple-pipeline-destination.yaml
```

## 🔧 Destination Types

### Alert Destinations
Used for **sending alert notifications**.

**HTTP Alert:**
```yaml
name: "slack-alerts"
type: http
url: "https://hooks.slack.com/services/XXX"
method: post
template: "slack-template"
```

**Email Alert:**
```yaml
name: "email-alerts"
type: email
emails:
  - "team@company.com"
template: "email-html-alert"
```

### Pipeline Destinations
Used for **data forwarding** in pipelines.

**Splunk:**
```yaml
name: "splunk-pipeline"
type: http
destinationTypeName: splunk
url: "https://splunk.company.com:8088/services/collector"
method: post
headers:
  Authorization: "Splunk YOUR-TOKEN"
```

**Elasticsearch:**
```yaml
name: "es-pipeline"
type: http
destinationTypeName: elasticsearch
url: "https://elasticsearch.company.com:9200/_bulk"
method: post
headers:
  Authorization: "Basic BASE64"
  Content-Type: "application/x-ndjson"
outputFormat:
  esbulk:
    index: "logs"
```

## 💡 Destination Commands

### List Destinations
```bash
# List all destinations
o2 list destination
o2 dest list

# Filter by type
o2 list dest --type http
o2 list dest --type email

# Different output formats
o2 list dest --output json
o2 list dest --output yaml
o2 list dest --output wide
```

### Get Destination Details
```bash
# Get specific destination by name
o2 get dest my-destination
o2 dest get my-destination

# Export to YAML
o2 get dest my-destination --output yaml
```

### Create Destination
```bash
# Create from file
o2 create dest -f destination.yaml
o2 dest create -f destination.yaml

# With specific profile
o2 create dest -f destination.yaml --profile prod
```

### Update Destination
```bash
# Update from file (auto-extracts name from file)
o2 update dest -f destination.yaml
o2 dest update -f destination.yaml

# Update with explicit name (can differ from file)
o2 update dest MyDestination -f updated.yaml
```

### Delete Destination
```bash
# Delete by name
o2 delete dest my-destination
o2 dest delete my-destination

# Delete from file (extracts name from file)
o2 delete dest -f destination.yaml
```

## 🎯 Complete Workflow Example

```bash
# 1. Create a destination
o2 create dest -f simple-http-alert-destination.yaml

# 2. List to verify
o2 list dest

# 3. Get details
o2 get dest slack-alerts

# 4. Update configuration
o2 update dest -f simple-http-alert-destination.yaml

# 5. Delete when done
o2 delete dest slack-alerts
```

## 📝 Field Reference

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | ✅ | Unique destination name |
| `type` | string | ✅ | http or email |
| `url` | string | For http | Webhook URL |
| `method` | string | No | post, put, get (default: post) |
| `headers` | map | No | HTTP headers |
| `template` | string | No | Alert template name |
| `emails` | array | For email | Email addresses |
| `skipTlsVerify` | bool | No | Skip TLS verification |
| `destinationTypeName` | string | No | For pipelines: splunk, elasticsearch, etc. |
| `outputFormat` | string/object | No | Format for pipeline destinations (json, nestedevent, or object) |

## 🎯 Examples

### Slack Webhook
```yaml
name: "slack-critical"
type: http
url: "https://hooks.slack.com/services/T00/B00/XXX"
method: post
template: "slack-alert"
```

### Email Alerts
```yaml
name: "team-email"
type: email
emails:
  - "team@company.com"
  - "oncall@company.com"
template: "email-html-alert"
```

### PagerDuty
```yaml
name: "pagerduty-critical"
type: http
url: "https://events.pagerduty.com/v2/enqueue"
method: post
headers:
  Authorization: "Token token=YOUR-INTEGRATION-KEY"
  Content-Type: "application/json"
template: "pagerduty-template"
```

### Splunk HEC
```yaml
name: "splunk-logs"
type: http
destinationTypeName: splunk
url: "https://splunk.company.com:8088/services/collector"
method: post
headers:
  Authorization: "Splunk YOUR-HEC-TOKEN"
outputFormat: nestedevent
```

## 🔗 More Information

- See [COMMANDS.md](../../docs/COMMANDS.md) for complete command reference
- See [Alert Templates](../templates/README.md) for creating alert templates
- See [Alerts](../alerts/README.md) for using destinations with alerts
