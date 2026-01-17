# Simple CLI Template Format

For O2 CLI, use this minimal YAML format:

## Required Fields

```yaml
name: "template-name"    # Unique name (required)
type: http               # Type: http, email, sns, or action (required)
body: |                  # Template content (required)
  Your template here
  Variables: {{alert_name}}
isBody: true            # Set to true for body content
```

## Field Descriptions

- **name**: Unique identifier for the template
- **type**: Template type
  - `http` - For webhooks (Slack, PagerDuty, custom HTTP endpoints)
  - `email` - For email notifications (requires `title` field)
  - `sns` - For AWS SNS
  - `action` - For action-based templates
- **body**: The actual template content (supports variables)
- **title**: Email subject (required for `type: email`)
- **isBody**: Set to `true` to use body, `false` to use as title only

## Examples

### HTTP/Slack Template
```yaml
name: "slack-critical"
type: http
body: |
  {
    "text": "Alert: {{alert_name}}",
    "priority": "critical"
  }
isBody: true
```

### Email Template
```yaml
name: "email-alert"
type: email
title: "Alert: {{alert_name}}"
body: |
  <html>
  <body>
    <h2>{{alert_name}}</h2>
    <p>Count: {{alert_count}}</p>
  </body>
  </html>
isBody: true
```

### SNS Template
```yaml
name: "sns-alert"
type: sns
body: |
  Alert: {{alert_name}}
  Details: {{alert_details}}
isBody: true
```

## ❌ What You DON'T Need

- ❌ `apiVersion`
- ❌ `kind`
- ❌ `metadata`
- ❌ `spec`
- ❌ `configRef`
- ❌ `namespace`

**Just the template fields!** The CLI handles the rest.
