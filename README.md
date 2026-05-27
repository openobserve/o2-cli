# O2 CLI - OpenObserve Command Line Interface

**Enterprise-Grade CLI for OpenObserve Management**

Version: 1.1.3 | Status: Production-Ready ✅

⚠️ **Requires OpenObserve Enterprise** - O2 CLI only works with OpenObserve Enterprise edition.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Resources](#resources)
- [Command Syntaxes](#command-syntaxes)
- [Examples](#examples)
- [Documentation](#documentation)

---

## 🎯 Overview

O2 CLI is a command-line interface for managing OpenObserve resources directly, similar to AWS CLI or kubectl. It provides an imperative way to manage OpenObserve alongside the declarative Kubernetes Operator.

**⚠️ Enterprise Requirement:**
O2 CLI requires **OpenObserve Enterprise** edition. It will not work with the community version. For Enterprise access, visit [openobserve.ai/pricing](https://openobserve.ai/pricing).

**Why O2 CLI?**
- ✅ Direct management without Kubernetes
- ✅ Quick ad-hoc operations
- ✅ Multi-environment support
- ✅ Scripting and automation
- ✅ Resource querying and export

---

## ✨ Features

### **Resource Management**
- ✅ **6 Resources with Full CRUD**: Dashboards, Templates, Destinations, Pipelines, Functions, Alerts
- ✅ **7 Resources Queryable**: Including Organizations
- ✅ **Raw API Format by Default**: Pass the OpenObserve API JSON directly — no Kubernetes wrapper needed
- ✅ **CRD Format Supported**: Use `--crd` flag to use Kubernetes CRD YAML format

### **Enterprise Capabilities**
- ✅ **Multi-Environment**: Unlimited profiles (dev, staging, prod)
- ✅ **Multi-Tenant**: Query across 21+ organizations
- ✅ **4 Output Formats**: table, JSON, YAML, wide
- ✅ **2 Command Syntaxes**: kubectl-style + resource-first

### **Advanced Features**
- ✅ Auto-detection of YAML format (simple vs full K8s)
- ✅ Flexible delete/update (by name or from file)
- ✅ Auto-defaults for missing fields
- ✅ Filtering (folder, type, enabled-only)
- ✅ Organization override
- ✅ **Prometheus Migration**: Import rules as OpenObserve alerts, export rules to YAML, or generate Kubernetes CRD manifests — all from a local file or live Prometheus instance

---

## 📦 Installation

### Quick Install (macOS/Linux)
```bash
curl -fsSL https://raw.githubusercontent.com/openobserve/o2-cli/main/install.sh | bash
```

### Homebrew (Recommended)
```bash
brew tap openobserve/tap
brew install o2
```

### Download Binary Directly
```bash
# macOS Apple Silicon
curl -L https://github.com/openobserve/o2-cli/releases/latest/download/o2-darwin-arm64.tar.gz | tar xz
sudo mv o2 /usr/local/bin/

# macOS Intel
curl -L https://github.com/openobserve/o2-cli/releases/latest/download/o2-darwin-amd64.tar.gz | tar xz
sudo mv o2 /usr/local/bin/

# Linux AMD64
curl -L https://github.com/openobserve/o2-cli/releases/latest/download/o2-linux-amd64.tar.gz | tar xz
sudo mv o2 /usr/local/bin/
```

---

## 🚀 Quick Start

### Prerequisites
- OpenObserve Enterprise instance
- Valid credentials (username/password or API token)

### 1. Configure
```bash
# Setup default profile
o2 configure
# Enter: endpoint, organization, username, password

# Setup additional environments
o2 configure --profile dev
o2 configure --profile prod
```

**Note:** The CLI will validate your OpenObserve instance is Enterprise edition on first command.

### 2. List Resources
```bash
# List all organizations
o2 list organizations

# Get organization summary
o2 organization get default --summary

# List dashboards
o2 list dashboard --folder production

# List alerts
o2 list alert --folder default --enabled-only
```

### 3. Manage Resources
```bash
# Create a template (raw API format, default)
o2 create template -f slack-alert.json

# Create using Kubernetes CRD format
o2 create template -f slack-alert.yaml --crd

# List templates
o2 list template

# Delete a template
o2 delete template old-template
```

---

## ⚙️ Configuration

### Profile Management

**Configure Multiple Environments:**
```bash
o2 configure                    # Default profile
o2 configure --profile dev      # Dev environment
o2 configure --profile staging  # Staging environment
o2 configure --profile prod     # Production environment
```

**List All Profiles:**
```bash
o2 configure list
```

**Config File Location:** `~/.o2/config.yaml`

**Example Config:**
```yaml
profiles:
  default:
    endpoint: https://openobserve.company.com
    organization: default
    username: user@company.com
    password: your-password
  dev:
    endpoint: https://dev.openobserve.com
    organization: dev-org
    username: dev-user@company.com
    password: dev-password
```

---

## 📊 Resources

### **Full CRUD Operations:**

| Resource | Create | List | Get | Update | Delete | Samples |
|----------|--------|------|-----|--------|--------|---------|
| **Organizations** | ✅ | ✅ | ✅ (+ summary) | - | - | - |
| **Dashboards** | ✅ | ✅ | ✅ | ✅ | ✅ (by ID) | Operator samples |
| **Templates** | ✅ | ✅ | ✅ | ✅ | ✅ | 6 files |
| **Destinations** | ✅ | ✅ | ✅ | ✅ | ✅ | 3 files |
| **Pipelines** | ✅ | ✅ | ✅ | ✅ | ✅ | 2 files |
| **Functions** | ✅ | ✅ | ✅ | ✅ | ✅ | 5 files |
| **Alerts** | ✅ | ✅ | ✅ | ✅ | ✅ | 2 files |

---

## 🎯 Command Syntaxes

O2 CLI supports **TWO syntaxes** - use whichever you prefer!

### **kubectl-Style (Verb-First)**
```bash
o2 <verb> <resource> [name] [flags]

# Examples:
o2 list template
o2 get dashboard 123456
o2 create template -f template.json
o2 update pipeline -f pipeline.yaml --crd
o2 delete function my-function
```

### **Resource-First**
```bash
o2 <resource> <verb> [name] [flags]

# Examples:
o2 template list
o2 dashboard get 123456
o2 template create -f template.json
o2 pipeline update -f pipeline.yaml --crd
o2 function delete my-function
```

**Both syntaxes do the same thing!**

### **File Format Flags (create commands)**

| Flag | Description |
|------|-------------|
| _(none)_ | **Default** — raw OpenObserve API JSON format |
| `--crd` | Kubernetes CRD YAML format (full `apiVersion`/`kind`/`spec` wrapper) |
| `--folder <name>` | Override the target folder (alerts and dashboards only) |

```bash
# Raw API format (default) — use JSON exported directly from OpenObserve
o2 create alert -f pod_failed.json
o2 create alert -f pod_failed.json --folder my-team

# Kubernetes CRD format
o2 create alert -f pod_failed.yaml --crd
o2 create alert -f pod_failed.yaml --crd --folder my-team
```

---

## 💡 Examples

### Multi-Environment Workflow
```bash
# Create in dev (raw API format, default)
o2 create template -f alert.json --profile dev

# Test it
o2 list template --profile dev

# Export from dev
o2 get template MyAlert --profile dev -o json > tested.json

# Deploy to prod
o2 create template -f tested.json --profile prod
```

### Migrate from Prometheus
```bash
# Dry-run to preview what would be created
o2 alert import-prometheus -f prometheus-rules.yaml --destination my-slack --dry-run

# Import all alerting rules from a local rules file
o2 alert import-prometheus -f prometheus-rules.yaml \
  --destination my-slack \
  --folder imported-from-prometheus \
  --stream my_metrics

# Import from a live Prometheus instance
o2 alert import-prometheus \
  --prometheus-url http://prometheus:9090 \
  --destination pagerduty \
  --folder production-alerts

# Merge rules from both a file and a live instance
o2 alert import-prometheus \
  -f extra-rules.yaml \
  --prometheus-url http://prometheus:9090 \
  --destination my-slack

# Export Prometheus rules to a local file (for review or offline use)
o2 alert export-prometheus --prometheus-url http://prometheus:9090 -f rules.yaml

# Generate Kubernetes CRD manifests (for use with O2 operator)
o2 alert generate-k8s \
  -f rules.yaml \
  --destination my-slack \
  --config-ref openobserve-account \
  --namespace o2operator \
  --folder PromethusRules \
  --output-file alerts-k8s.yaml

# Or pipe directly to kubectl
o2 alert generate-k8s -f rules.yaml --destination my-slack --config-ref openobserve-account | kubectl apply -f -
```

### Cross-Organization Querying
```bash
# List all organizations
o2 list organizations

# Query different orgs
o2 list alert --org org1
o2 list dashboard --org org2 --folder monitoring
o2 list function --org org3
```

### Backup and Restore
```bash
# Backup all templates (exports raw API format JSON)
for t in $(o2 list template --output json | jq -r '.[].name'); do
  o2 get template $t -o json > backups/${t}.json
done

# Restore templates (raw format is the default)
for f in backups/*.json; do
  o2 create template -f $f
done
```

### Resource Management
```bash
# Create destination (raw API format, default)
o2 create dest -f slack-webhook.json

# List HTTP destinations
o2 list dest --type http

# Update destination
o2 update dest -f updated-webhook.json

# Delete destination
o2 delete dest slack-webhook
```

---

## 📚 Documentation

### Core Documentation
- **COMMANDS.md** - Complete command reference with syntax
- **README.md** - This file

### Sample Files
Located in `samples/` directory:
- `templates/` - 6 alert template samples
- `destinations/` - 3 destination samples
- `pipelines/` - 2 pipeline samples
- `functions/` - 5 function samples
- `dashboards/` - 2 dashboard samples
- `alerts/` - 2 alert samples

### Developer Documentation
Located in `docs/` directory:
- `ARCHITECTURE.md` - Technical architecture
- `IMPLEMENTATION_PLAN.md` - Development roadmap
- `TESTING.md` - Testing guide
- `PROFILES.md` - Multi-environment setup
- `DISTRIBUTION.md` - Packaging and distribution

---

## 🔧 Global Flags

Available on all commands:

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--profile` | | `default` | Use specific profile |
| `--org` | | From profile | Override organization |
| `--output` | `-o` | `table` | Output format: table, json, yaml, wide |
| `--config` | | `~/.o2/config.yaml` | Custom config file |

---

## 🎯 Common Operations

### Organizations
```bash
o2 organization list
o2 organization get default --summary
o2 organization create myorg --identifier myorg
o2 get organization myorg --summary
```

### Templates
```bash
o2 create template -f template.json              # raw API format (default)
o2 create template -f template.yaml --crd        # Kubernetes CRD format
o2 list template
o2 delete template MyTemplate
```

### Destinations
```bash
o2 create dest -f destination.json               # raw API format (default)
o2 create dest -f destination.yaml --crd         # Kubernetes CRD format
o2 list dest --type http
o2 delete dest my-destination
```

### Dashboards
```bash
o2 create dashboard -f dashboard.json            # raw API format (default)
o2 create dashboard -f dashboard.json --folder production  # override folder
o2 create dashboard -f dashboard.yaml --crd      # Kubernetes CRD format
o2 list dashboard --folder production
o2 delete dashboard 7417863561566760960          # Use ID from list
```

### Pipelines
```bash
o2 create pipeline -f pipeline.json              # raw API format (default)
o2 create pipeline -f pipeline.yaml --crd        # Kubernetes CRD format
o2 list pipeline
o2 delete pipeline my-pipeline
```

### Functions
```bash
o2 create function -f function.json              # raw API format (default)
o2 create function -f function.yaml --crd        # Kubernetes CRD format
o2 list function
o2 delete function my-function
```

### Alerts
```bash
o2 create alert -f alert.json                    # raw API format (default)
o2 create alert -f alert.json --folder my-team   # override folder
o2 create alert -f alert.yaml --crd              # Kubernetes CRD format
o2 create alert -f alert.yaml --crd --folder my-team
o2 list alert --folder test_alerts --enabled-only
o2 get alert my-alert
o2 update alert -f updated-alert.yaml
o2 delete alert my-alert

# Import from Prometheus (creates alerts in OpenObserve)
o2 alert import-prometheus -f rules.yaml --destination my-slack
o2 alert import-prometheus --prometheus-url http://prometheus:9090 --destination my-slack
o2 alert import-prometheus -f rules.yaml --destination my-slack --folder imported --dry-run

# Export from Prometheus (save rules to local file)
o2 alert export-prometheus --prometheus-url http://prometheus:9090
o2 alert export-prometheus --prometheus-url http://prometheus:9090 -f rules.yaml

# Generate Kubernetes CRD manifests (for O2 operator)
o2 alert generate-k8s -f rules.yaml --destination my-slack --config-ref openobserve-account
o2 alert generate-k8s -f rules.yaml --destination my-slack --config-ref openobserve-account | kubectl apply -f -
o2 alert generate-k8s -f rules.yaml --destination my-slack --config-ref openobserve-account --output-file alerts.yaml
```

---

## 🌍 Multi-Environment Usage

```bash
# Configure environments
o2 configure --profile dev
o2 configure --profile prod

# Use different environments
o2 list template --profile dev
o2 create template -f alert.yaml --profile prod
o2 list dashboard --profile staging --folder monitoring
```

---

## 📊 Statistics

**What's Available:**
- Commands: 90+
- Working: 60+
- Full CRUD Resources: 6
- Query Resources: 7
- Sample Files: 18+
- Organizations: 21+

---

## 🚀 Production Ready

O2 CLI is production-ready for:
- Alert template management
- Destination configuration
- Pipeline lifecycle
- Function management
- Dashboard management
- Resource querying and auditing
- Multi-environment workflows
- Backup and restore operations

---

## 🔗 Related Tools

**Kubernetes Operator:** For GitOps and declarative management (CRD format)
```bash
kubectl apply -f dashboard.yaml
```

**O2 CLI — Raw API format** (default): use JSON exported directly from OpenObserve
```bash
o2 create dashboard -f dashboard.json
o2 create alert -f alert.json --folder my-team
```

**O2 CLI — CRD format**: use the same YAML files as the Kubernetes Operator
```bash
o2 create dashboard -f dashboard.yaml --crd
o2 create alert -f alert.yaml --crd --folder my-team
```

**Use both together for complete OpenObserve management!**

---

## 📖 Getting Help

```bash
# General help
o2 --help

# Command help
o2 list --help
o2 create --help
o2 delete --help

# Resource-specific help
o2 template --help
o2 dashboard --help
o2 pipeline --help
```

---

## 🎉 Success Stories

**Manage OpenObserve like a pro:**
- Create and manage alert templates across environments
- Configure destinations for Slack, PagerDuty, Email
- Deploy pipelines for data routing
- Manage VRL functions for data transformation
- Query resources across 21+ organizations

---

**For detailed command syntax, see [COMMANDS.md](COMMANDS.md)**

**For samples, see `samples/` directory**

**For advanced topics, see `docs/` directory**
