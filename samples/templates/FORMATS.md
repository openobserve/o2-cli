# Template YAML Formats

O2 CLI supports TWO formats for template YAML files.

## ✨ Simple Format (Recommended)

**What you need:**
```yaml
name: "template-name"
body: |
  Your template content here
  Variables: {{alert_name}}
isBody: true
```

**That's it!** No Kubernetes fields needed.

## 📦 Full Kubernetes Format

**For kubectl compatibility:**
```yaml
apiVersion: openobserve.ai/v1alpha1
kind: OpenObserveAlertTemplate
metadata:
  name: template-k8s-name
  namespace: o2operator
spec:
  configRef:
    name: openobserve-main
  name: "template-name"
  body: |
    Your template content
  org: "default"  # Optional
```

## 🔄 Auto-Detection

The CLI automatically detects which format you're using:

```bash
# Works with simple format
o2 template create -f simple-template.yaml

# Also works with full K8s format
o2 template create -f k8s-template.yaml
```

## 💡 Recommendation

**Use Simple Format for CLI:**
- ✅ Less typing
- ✅ Cleaner files
- ✅ No unnecessary fields

**Use Full Format when:**
- Sharing with kubectl users
- Converting operator resources
- Need metadata for tracking
