# O2 CLI - Alert Template Samples

Sample alert templates for use with O2 CLI.

## 📋 Two YAML Formats Supported

### **Simple Format** (Recommended for CLI) ✨

Just the template fields - no Kubernetes wrapper:

```yaml
name: "my-template"
body: |
  Alert: {{alert_name}}
  Count: {{alert_count}}
isBody: true
```

**✅ Benefits:**
- Cleaner, less verbose
- No Kubernetes-specific fields
- Easier to write and understand

### **Full Kubernetes Format** (For kubectl compatibility)

Full Kubernetes resource with metadata:

```yaml
apiVersion: openobserve.ai/v1alpha1
kind: OpenObserveAlertTemplate
metadata:
  name: my-template
  namespace: o2operator
spec:
  configRef:
    name: openobserve-main
  name: "my-template"
  body: |
    Alert: {{alert_name}}
    Count: {{alert_count}}
```

**Use when:**
- You want compatibility with kubectl
- You're converting from operator resources

**Both formats work!** The CLI auto-detects which format you're using.

---

## Available Samples

### Simple Format (CLI-Friendly) ✨

**1. simple-http-template.yaml** ✨
Simple HTTP/JSON alert template.

**Format:** Simple (no Kubernetes fields)

**Usage:**
```bash
o2 template create -f simple-http-template.yaml
```

**2. simple-slack-template.yaml** ✨
Slack webhook template with blocks.

**Format:** Simple

**Usage:**
```bash
o2 template create -f simple-slack-template.yaml
```

**3. simple-email-template.yaml** ✨
HTML email template.

**Format:** Simple

**Usage:**
```bash
o2 template create -f simple-email-template.yaml
```

### Full Kubernetes Format

**4. http-alert-template.yaml
HTTP webhook alert template for sending alerts to custom endpoints.

**Usage:**
```bash
o2 template create -f http-alert-template.yaml
```

### 2. email-html-alert-template.yaml
HTML email alert template for formatted email notifications.

**Usage:**
```bash
o2 template create -f email-html-alert-template.yaml
```

### 3. http-slack-webhook-template.yaml
Slack webhook template for sending alerts to Slack channels.

**Usage:**
```bash
o2 template create -f http-slack-webhook-template.yaml
```

## Template Structure

```yaml
apiVersion: openobserve.ai/v1alpha1
kind: OpenObserveAlertTemplate
metadata:
  name: my-template
  namespace: o2operator
spec:
  configRef:
    name: openobserve-main
  name: "MyTemplate"
  body: |
    Alert triggered!
    Details: {{alert_details}}
  isBody: true
```

## Commands

### Create Template
```bash
o2 template create -f my-template.yaml
o2 template create -f my-template.yaml --profile prod
o2 template create -f my-template.yaml --org myorg
```

### List Templates
```bash
o2 template list
o2 list template
o2 list template --output json
```

### Get Template
```bash
o2 template get StandardAlert
o2 template get StandardAlert --output yaml > backup.yaml
```

### Update Template
```bash
o2 template update StandardAlert -f updated-template.yaml
```

### Delete Template
```bash
o2 template delete old-template
```

## Template Variables

Templates support variables that are replaced when alerts are triggered:

Common variables:
- `{{alert_name}}` - Name of the alert
- `{{alert_type}}` - Type of alert
- `{{alert_period}}` - Alert evaluation period
- `{{alert_operator}}` - Threshold operator
- `{{alert_threshold}}` - Threshold value
- `{{alert_count}}` - Number of occurrences
- Custom variables from alert context attributes

## Tips

1. **Test templates** before deploying to production
2. **Use variables** to make templates reusable
3. **Export existing** templates as starting point:
   ```bash
   o2 template get StandardAlert -o yaml > my-template.yaml
   ```
4. **Validate YAML** before creating:
   ```bash
   yamllint my-template.yaml
   ```

## Examples

### Create from sample
```bash
cd o2-cli/samples/templates
o2 template create -f http-slack-webhook-template.yaml
```

### Export and modify
```bash
o2 template get StandardAlert -o yaml > custom-alert.yaml
# Edit custom-alert.yaml
o2 template create -f custom-alert.yaml
```

### Update existing
```bash
o2 template get MyTemplate -o yaml > mytemplate.yaml
# Edit mytemplate.yaml
o2 template update MyTemplate -f mytemplate.yaml
```

## More Information

- [O2 CLI Documentation](../../README.md)
- [Operator Template Samples](../../../o2-k8s-operator/samples/alerttemplates/)
