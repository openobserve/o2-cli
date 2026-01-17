# O2 CLI - Pipeline Samples

Sample pipeline configurations for O2 CLI.

## 📋 Pipeline Format

**Note:** Pipelines are complex and use the full Kubernetes YAML format.

```yaml
apiVersion: openobserve.ai/v1alpha1
kind: OpenObservePipeline
metadata:
  name: my-pipeline
  namespace: o2operator
spec:
  configRef:
    name: openobserve-main
  name: "my-pipeline"
  description: "Pipeline description"
  enabled: true
  source:
    streamType: logs
    streamName: "source-stream"
    # ... source configuration
  nodes:
    - # Node definitions
  edges:
    - # Edge connections
```

## 📁 Available Samples

**1. real-time-pipeline1.yaml**
Real-time data processing pipeline.

**Usage:**
```bash
o2 pipeline create -f real-time-pipeline1.yaml
```

## 💡 Commands

### Create Pipeline
```bash
o2 pipeline create -f pipeline.yaml
o2 pipeline create -f pipeline.yaml --profile prod
```

### List Pipelines
```bash
o2 pipeline list
o2 list pipeline
o2 pipeline list --output json
```

### Get Pipeline
```bash
o2 pipeline get my-pipeline
o2 pipeline get my-pipeline --output yaml > backup.yaml
```

### Update Pipeline
```bash
# Auto-extract name
o2 pipeline update -f pipeline.yaml

# Explicit name
o2 pipeline update MyPipeline -f updated.yaml
```

### Delete Pipeline
```bash
# By name
o2 pipeline delete my-pipeline

# From file
o2 pipeline delete -f pipeline.yaml
```

### Pause/Resume
```bash
o2 pipeline pause my-pipeline
o2 pipeline resume my-pipeline
```

## 📝 Pipeline Components

Pipelines consist of:
- **Source**: Where data comes from (stream, query, or schedule)
- **Nodes**: Processing steps (functions, transformations)
- **Edges**: Connections between nodes defining data flow
- **Enabled**: Whether pipeline is active

## 🔗 More Information

- [Operator Pipeline Samples](../../../o2-k8s-operator/samples/pipelines/)
- [O2 CLI Commands](../../O2_CLI_COMMANDS.md)
