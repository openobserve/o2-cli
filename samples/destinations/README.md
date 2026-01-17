# O2 CLI - Destination Samples

Sample destination configurations for O2 CLI.

## 📋 Simple CLI Format

```yaml
name: "destination-name"              # Required
type: http                            # Required: http, email, sns
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

**SNS Alert:**
```yaml
name: "sns-alerts"
type: sns
actionId: "arn:aws:sns:..."
awsRegion: "us-east-1"
snsTopicArn: "arn:aws:sns:..."
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
url: "https://elasticsearch.company.com:9200"
method: post
headers:
  Authorization: "Basic BASE64"
```

## 💡 Commands

### Create
```bash
o2 dest create -f destination.yaml
o2 destination create -f destination.yaml --profile prod
```

### List
```bash
o2 dest list
o2 dest list --type http
o2 list destination
```

### Get
```bash
o2 dest get my-destination
o2 dest get my-destination --output yaml
```

### Update
```bash
# Auto-extract name
o2 dest update -f destination.yaml

# Explicit name
o2 dest update MyDestination -f updated.yaml
```

### Delete
```bash
# By name
o2 dest delete my-destination

# From file
o2 dest delete -f destination.yaml
```

## 📝 Field Reference

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | ✅ | Unique destination name |
| `type` | string | ✅ | http, email, or sns |
| `url` | string | For http | Webhook URL |
| `method` | string | No | post, put, get (default: post) |
| `headers` | map | No | HTTP headers |
| `template` | string | No | Alert template name |
| `emails` | array | For email | Email addresses |
| `skipTlsVerify` | bool | No | Skip TLS verification |
| `destinationTypeName` | string | No | For pipelines: splunk, elasticsearch, etc. |

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
```

## 🔗 More Information

- [O2 CLI Commands](../../O2_CLI_COMMANDS.md)
- [Filtering Guide](../../FILTERING_GUIDE.md)
