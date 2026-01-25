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

## 💡 Pipeline Commands

### List Pipelines
```bash
# List all pipelines
o2 list pipeline
o2 pipeline list

# Different output formats
o2 list pipeline --output json
o2 list pipeline --output yaml
o2 list pipeline --output wide
```

### Get Pipeline Details
```bash
# Get specific pipeline by name
o2 get pipeline my-pipeline
o2 pipeline get my-pipeline

# Export to YAML (for backup)
o2 get pipeline my-pipeline --output yaml > backup.yaml
```

### Create Pipeline
```bash
# Create from file
o2 create pipeline -f pipeline.yaml
o2 pipeline create -f pipeline.yaml

# With specific profile
o2 create pipeline -f pipeline.yaml --profile prod
```

### Update Pipeline
```bash
# Update from file (auto-extracts name from file)
o2 update pipeline -f pipeline.yaml
o2 pipeline update -f pipeline.yaml

# Update with explicit name (can differ from file)
o2 update pipeline MyPipeline -f updated.yaml
```

### Delete Pipeline
```bash
# Delete by name
o2 delete pipeline my-pipeline
o2 pipeline delete my-pipeline

# Delete from file (extracts name from file)
o2 delete pipeline -f pipeline.yaml
```

### Pause/Resume Pipeline
```bash
# Pause a running pipeline
o2 pipeline pause my-pipeline

# Resume a paused pipeline
o2 pipeline resume my-pipeline
```

## 🎯 Complete Workflow Example

```bash
# 1. Create a pipeline
o2 create pipeline -f real-time-pipeline1.yaml

# 2. List to verify
o2 list pipeline

# 3. Get details
o2 get pipeline my-pipeline

# 4. Pause temporarily for maintenance
o2 pipeline pause my-pipeline

# 5. Resume after maintenance
o2 pipeline resume my-pipeline

# 6. Update configuration
o2 update pipeline -f real-time-pipeline1.yaml

# 7. Delete when done
o2 delete pipeline my-pipeline
```

## 📝 Pipeline Components

Pipelines consist of:
- **Source**: Where data comes from (stream, query, or schedule)
- **Nodes**: Processing steps (functions, transformations)
- **Edges**: Connections between nodes defining data flow
- **Enabled**: Whether pipeline is active

## 🔗 More Information

- See [COMMANDS.md](../../docs/COMMANDS.md) for complete command reference
- See [Functions](../functions/README.md) for creating VRL functions to use in pipelines
- See [Destinations](../destinations/README.md) for pipeline destinations
