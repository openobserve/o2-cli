# O2 CLI - Complete Command Reference

**All Available Commands with Detailed Syntax**

Version: 1.0.0

---

## 📋 Table of Contents

- [Global Flags](#global-flags)
- [Configuration Commands](#configuration-commands)
- [List Commands](#list-commands)
- [Create Commands](#create-commands)
- [Get Commands](#get-commands)
- [Update Commands](#update-commands)
- [Delete Commands](#delete-commands)
- [Resource-Specific Commands](#resource-specific-commands)

---

## 🌐 Global Flags

Available on **ALL** commands:

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--profile <name>` | | `default` | Use specific profile/environment |
| `--org <name>` | | From profile | Override organization |
| `--output <format>` | `-o` | `table` | Output format: `table`, `json`, `yaml`, `wide` |
| `--config <path>` | | `~/.o2/config.yaml` | Custom config file path |

---

## ⚙️ Configuration Commands

### `o2 configure`
**Description:** Interactive configuration setup

**Usage:**
```bash
o2 configure                    # Configure default profile
o2 configure --profile dev      # Configure dev profile
o2 configure --profile prod     # Configure prod profile
```

**Prompts for:**
- OpenObserve Endpoint URL
- Organization name
- Username
- Account type selection:
  1. User account (uses password)
  2. Service account (uses token)
- Password (for user accounts) OR Token (for service accounts)

**Config saved to:** `~/.o2/config.yaml`

**Note:** Service accounts have limited permissions and cannot access report folders

---

### `o2 configure list`
**Description:** List all configured profiles

**Usage:**
```bash
o2 configure list
```

**Output:**
```
Configured profiles:
  default:
    endpoint: https://openobserve.company.com
    organization: default
  dev:
    endpoint: https://dev.openobserve.com
    organization: dev-org
```

---

### `o2 configure get <key>`
**Description:** Get specific configuration value

**Usage:**
```bash
o2 configure get endpoint --profile dev
o2 configure get organization --profile prod
```

**Keys:** `endpoint`, `organization`, `username`, `password`

---

## 📝 List Commands

### `o2 list organizations`
**Aliases:** `orgs`, `org`

**Description:** List all organizations

**Usage:**
```bash
o2 list organizations
o2 list orgs                    # Alias
o2 list organizations --output json
```

**Flags:**
- All global flags

**Example Output:**
```
ID   IDENTIFIER   NAME          TYPE
20   default      default       default
10   dev-org      dev-org       custom
```

---

### `o2 list dashboard`
**Aliases:** `dashboards`, `dash`

**Description:** List dashboards

**Usage:**
```bash
o2 list dashboard
o2 list dashboard --folder production
o2 list dashboard --org myorg --folder monitoring
o2 dashboard list               # Alternative syntax
```

**Flags:**
- `--folder <name>` - Filter by folder (default: "default")
- All global flags

**Example Output:**
```
ID                    TITLE            FOLDER       CREATED
7417863561566760960   K8s Monitoring   production   2026-01-16T09:41:29.910Z
```

---

### `o2 list alert`
**Aliases:** `alerts`

**Description:** List alerts

**Usage:**
```bash
o2 list alert
o2 list alert --folder default
o2 list alert --enabled-only
o2 list alert --folder ProductionAlerts --enabled-only
o2 alert list                   # Alternative syntax
```

**Flags:**
- `--folder <name>` - Filter by folder (shows all if not specified)
- `--enabled-only` - Show only enabled alerts
- All global flags

**Example Output:**
```
ALERT_ID                      NAME                   FOLDER        QUERY_TYPE   ENABLED
38NaQA2QOXvOVPFni6FQJBla9bz   real-time-logs-alert   test_alerts   custom       true
323KmocLQwmA2Rlmws2UrmyOo6L   503                    default       sql          true
```

---

### `o2 list template`
**Aliases:** `templates`

**Description:** List alert templates

**Usage:**
```bash
o2 list template
o2 list template --output json
o2 template list                # Alternative syntax
```

**Flags:**
- All global flags

**Example Output:**
```
NAME               IS_BODY
StandardAlert      true
slack-alert        true
```

---

### `o2 list destination`
**Aliases:** `destinations`, `dest`

**Description:** List destinations

**Usage:**
```bash
o2 list destination
o2 list dest --type http
o2 dest list                    # Alternative syntax
```

**Flags:**
- `--type <type>` - Filter by type: `http`, `email`
- All global flags

**Example Output:**
```
NAME              TYPE   CATEGORY
slack-webhook     http   alert
email-alerts      email  alert
```

---

### `o2 list pipeline`
**Aliases:** `pipelines`, `pipe`

**Description:** List pipelines

**Usage:**
```bash
o2 list pipeline
o2 pipeline list                # Alternative syntax
```

**Flags:**
- All global flags

**Example Output:**
```
NAME          STREAM_TYPE   ENABLED
parse_nginx                 true
```

---

### `o2 list folder`
**Aliases:** `folders`

**Description:** List folders

**Usage:**
```bash
o2 list folder                  # List alert folders (default)
o2 list folder --type dashboards
o2 list folder --type reports
o2 folder list --type alerts    # Alternative syntax
```

**Flags:**
- `--type <type>` - Folder type: `alerts`, `dashboards`, `reports` (default: "alerts")
- All global flags

**Example Output:**
```
ID                    NAME              TYPE        DESCRIPTION
7417863561566760960   default           alerts      Default folder
7417863561566760961   ProductionAlerts  alerts      Production monitoring
```

---

### `o2 list function`
**Aliases:** `functions`, `func`

**Description:** List functions

**Usage:**
```bash
o2 list function
o2 function list                # Alternative syntax
```

**Flags:**
- All global flags

**Example Output:**
```
NAME             STREAM_TYPE
parse_json
geoip_enrich
```

---

## ➕ Create Commands

### `o2 create organization <name>`
**Aliases:** `organizations`, `org`, `orgs`

**Description:** Create a new organization

**Usage:**
```bash
o2 create organization myorg
o2 create org myorg --identifier my_org_id
o2 organization create myorg --identifier myorg
```

**Flags:**
- `--identifier <id>` - Organization identifier (defaults to name if not specified)
- All global flags

**Example:**
```bash
# Create with auto identifier
o2 create organization dev

# Create with custom identifier
o2 create organization "Development Org" --identifier dev_org
```

---

### `o2 create alert`
**Aliases:** `alerts`

**Description:** Create alert from file

**Usage:**
```bash
o2 create alert -f alert.yaml
o2 alert create -f alert.yaml          # Alternative
```

**Flags:**
- `-f, --file <path>` - Alert YAML file (required)
- All global flags

**YAML Format:**
```yaml
apiVersion: openobserve.ai/v1alpha1
kind: OpenObserveAlert
metadata:
  name: my-alert
  namespace: o2operator
spec:
  configRef:
    name: openobserve-main
  name: "my-alert"
  enabled: true
  streamName: "default"
  streamType: "logs"
  isRealTime: true
  folderName: "default"
  destinations: ["webhook-dest"]
  queryCondition:
    type: "custom"
    conditions:
      or:
        - column: "level"
          operator: "="
          value: "ERROR"
          ignore_case: false
  triggerCondition:
    period: 15
    operator: ">="
    threshold: 1
    frequency: 1
    silence: 5
```

---

### `o2 create template`
**Description:** Create alert template from file

**Usage:**
```bash
o2 create template -f template.yaml
o2 template create -f template.yaml    # Alternative
```

**Flags:**
- `-f, --file <path>` - Template YAML file (required)
- All global flags

**YAML Format (Simple):**
```yaml
name: "my-template"
type: http              # http, email, sns, action
body: |
  Alert: {{alert_name}}
isBody: true
```

---

### `o2 create destination`
**Aliases:** `dest`

**Description:** Create destination from file

**Usage:**
```bash
o2 create dest -f destination.yaml
o2 dest create -f destination.yaml     # Alternative
```

**Flags:**
- `-f, --file <path>` - Destination YAML file (required)
- All global flags

**YAML Format (Simple):**
```yaml
name: "slack-webhook"
type: http
url: "https://hooks.slack.com/..."
method: post
template: "slack-alert"
```

---

### `o2 create pipeline`
**Aliases:** `pipe`

**Description:** Create pipeline from file

**Usage:**
```bash
o2 create pipeline -f pipeline.yaml
o2 pipeline create -f pipeline.yaml    # Alternative
```

**Flags:**
- `-f, --file <path>` - Pipeline YAML file (required)
- All global flags

**Note:** Uses full Kubernetes YAML format

---

### `o2 create folder`

**Description:** Create a new folder

**Usage:**
```bash
o2 create folder production-alerts
o2 create folder monitoring --type dashboards
o2 create folder quarterly --type reports --description "Quarterly reports"
o2 folder create dev-alerts --description "Development alerts"
```

**Flags:**
- `--type <type>` - Folder type: `alerts`, `dashboards`, `reports` (default: "alerts")
- `--description <desc>` - Folder description
- All global flags

**Example:**
```bash
# Create alert folder
o2 create folder ProductionAlerts --description "Production monitoring"

# Create dashboard folder
o2 create folder Monitoring --type dashboards
```

---

### `o2 create function`
**Aliases:** `func`

**Description:** Create VRL function from file

**Usage:**
```bash
o2 create function -f function.yaml
o2 function create -f function.yaml    # Alternative
```

**Flags:**
- `-f, --file <path>` - Function YAML file (required)
- All global flags

**YAML Format (Simple):**
```yaml
name: "my-function"
function: |
  # VRL code here
  .
```

---

### `o2 create dashboard`
**Aliases:** `dash`

**Description:** Create dashboard from file

**Usage:**
```bash
o2 create dashboard -f dashboard.yaml
o2 dashboard create -f dashboard.yaml  # Alternative
```

**Flags:**
- `-f, --file <path>` - Dashboard YAML file (required)
- All global flags

**Note:** Uses full Kubernetes YAML format

---

## 👁️ Get Commands

### `o2 get organization <name>`
**Aliases:** `organizations`, `org`, `orgs`

**Description:** Get organization details or summary

**Usage:**
```bash
o2 get organization default
o2 get org myorg --summary                   # With summary
o2 organization get default --summary        # Alternative
```

**Flags:**
- `--summary` - Show organization summary statistics
- All global flags

**Summary Output:**
```
Organization Summary: default
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Streams:    5 (Size: 1048576 bytes)
Functions:  3
Alerts:     2
Dashboards: 4
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### `o2 get alert <name>`
**Aliases:** `alerts`

**Description:** Get alert details by name

**Usage:**
```bash
o2 get alert my-alert
o2 alert get my-alert                    # Alternative
o2 get alert my-alert --output yaml      # Export format
```

**Flags:**
- All global flags

---

### `o2 get template <name>`
**Description:** Get template details

**Usage:**
```bash
o2 get template StandardAlert
o2 get template StandardAlert --output yaml
o2 template get StandardAlert           # Alternative
```

**Flags:**
- All global flags

---

### `o2 get destination <name>`
**Aliases:** `dest`

**Description:** Get destination details

**Usage:**
```bash
o2 get dest slack-webhook
o2 dest get slack-webhook               # Alternative
```

**Flags:**
- All global flags

---

### `o2 get pipeline <name>`
**Aliases:** `pipe`

**Description:** Get pipeline details

**Usage:**
```bash
o2 get pipeline my-pipeline
o2 pipeline get my-pipeline             # Alternative
```

**Flags:**
- All global flags

---

### `o2 get folder <name>`

**Description:** Get folder details

**Usage:**
```bash
o2 get folder ProductionAlerts                      # Get alert folder by name
o2 get folder Infrastructure --type dashboards      # Get dashboard folder by name
o2 get folder 7417863561566760960 --by-id          # Get alert folder by ID
o2 get folder 7417863561566760960 --by-id --type dashboards  # Get dashboard folder by ID
o2 folder get quarterly --type reports             # Alternative syntax
```

**Flags:**
- `--type <type>` - Folder type: `alerts`, `dashboards`, `reports` (default: "alerts")
- `--by-id` - Treat argument as folder ID instead of name (required when using IDs)
- All global flags

**Note:** Folders are namespaced by type. "Infrastructure" in alerts is different from "Infrastructure" in dashboards.

---

### `o2 get function <name>`
**Aliases:** `func`

**Description:** Get function details

**Usage:**
```bash
o2 get function my-function
o2 function get my-function             # Alternative
```

**Flags:**
- All global flags

---

### `o2 get dashboard <id>`
**Aliases:** `dash`

**Description:** Get dashboard by ID

**Usage:**
```bash
o2 get dashboard 7417863561566760960
o2 dashboard get 7417863561566760960    # Alternative
```

**Flags:**
- All global flags

**Note:** Requires numeric dashboard ID

---

## ✏️ Update Commands

### `o2 update alert`
**Aliases:** `alerts`

**Description:** Update alert by name or ID

**Usage:**
```bash
o2 update alert -f alert.yaml              # Auto-extract name from file
o2 update alert my-alert -f updated.yaml   # Update by name
o2 update alert 39z0R4KJlK5uyj0it2mmndNP2HC -f updated.yaml  # Update by ID
o2 alert update -f alert.yaml              # Alternative
```

**Flags:**
- `-f, --file <path>` - Alert YAML file (required)
- `[alert-name-or-id]` - Alert name or ID (optional if name is in file, IDs auto-detected if >20 chars)
- All global flags

---

### `o2 update template`
**Description:** Update template from file

**Usage:**
```bash
o2 update template -f template.yaml           # Auto-extract name from file
o2 update template MyTemplate -f updated.yaml # Explicit name
o2 template update -f template.yaml           # Alternative
```

**Flags:**
- `-f, --file <path>` - Template YAML file (required)
- `[template-name]` - Optional if name is in file
- All global flags

---

### `o2 update destination`
**Aliases:** `dest`

**Description:** Update destination from file

**Usage:**
```bash
o2 update dest -f destination.yaml
o2 dest update -f destination.yaml            # Alternative
```

**Flags:**
- `-f, --file <path>` - Destination YAML file (required)
- `[destination-name]` - Optional if name is in file
- All global flags

---

### `o2 update pipeline`
**Aliases:** `pipe`

**Description:** Update pipeline from file

**Usage:**
```bash
o2 update pipeline -f pipeline.yaml
o2 pipeline update -f pipeline.yaml           # Alternative
```

**Flags:**
- `-f, --file <path>` - Pipeline YAML file (required)
- `[pipeline-name]` - Optional if name is in file
- All global flags

---

### `o2 update folder`

**Description:** Update folder details

**Usage:**
```bash
o2 update folder 7417863561566760960 --name "New Name"
o2 update folder 7417863561566760960 --description "Updated description"
o2 update folder 7417863561566760960 --name "Prod" --description "Production folder"
o2 folder update 7417863561566760960 --type dashboards --name "Dashboard Storage"
```

**Flags:**
- `--type <type>` - Folder type: `alerts`, `dashboards`, `reports` (default: "alerts")
- `--name <name>` - New folder name
- `--description <desc>` - New folder description
- All global flags

**Note:** Requires folder ID, not name

---

### `o2 update function`
**Aliases:** `func`

**Description:** Update function from file

**Usage:**
```bash
o2 update function -f function.yaml
o2 function update -f function.yaml           # Alternative
```

**Flags:**
- `-f, --file <path>` - Function YAML file (required)
- `[function-name]` - Optional if name is in file
- All global flags

---

### `o2 update dashboard <id>`
**Aliases:** `dash`

**Description:** Update dashboard by ID

**Usage:**
```bash
o2 update dashboard 7417863561566760960 -f updated.yaml
o2 dashboard update 7417863561566760960 -f updated.yaml  # Alternative
```

**Flags:**
- `<dashboard-id>` - Dashboard ID (required)
- `-f, --file <path>` - Dashboard YAML file (required)
- All global flags

---

## 🗑️ Delete Commands

### `o2 delete alert`
**Aliases:** `alerts`

**Description:** Delete alert by name, ID, or from file

**Usage:**
```bash
o2 delete alert my-alert                # By name
o2 delete alert 39z0R4KJlK5uyj0it2mmndNP2HC  # By alert ID (auto-detected if >20 chars)
o2 delete alert -f alert.yaml           # From file
o2 alert delete my-alert                # Alternative
```

**Flags:**
- `[alert-name-or-id]` - Alert name or ID (IDs are auto-detected if >20 chars)
- `-f, --file <path>` - Extract name from file
- `--folder <name>` - Specify folder to search (optional, improves performance)
- All global flags

**Important:** You can use either alert **name** or **ID**. Get both from `o2 list alert`.

---

### `o2 delete template`
**Description:** Delete template by name or from file

**Usage:**
```bash
o2 delete template MyTemplate           # By name
o2 delete template -f template.yaml     # From file
o2 template delete MyTemplate           # Alternative
```

**Flags:**
- `[template-name]` - Template name OR
- `-f, --file <path>` - Extract name from file
- All global flags

---

### `o2 delete destination`
**Aliases:** `dest`

**Description:** Delete destination by name or from file

**Usage:**
```bash
o2 delete dest slack-webhook            # By name
o2 delete dest -f destination.yaml      # From file
o2 dest delete slack-webhook            # Alternative
```

**Flags:**
- `[destination-name]` - Destination name OR
- `-f, --file <path>` - Extract name from file
- All global flags

---

### `o2 delete pipeline`
**Aliases:** `pipe`

**Description:** Delete pipeline by name or from file

**Usage:**
```bash
o2 delete pipeline my-pipeline          # By name
o2 delete pipeline -f pipeline.yaml     # From file
o2 pipeline delete my-pipeline          # Alternative
```

**Flags:**
- `[pipeline-name]` - Pipeline name OR
- `-f, --file <path>` - Extract name from file
- All global flags

---

### `o2 delete folder`

**Description:** Delete folder

**Usage:**
```bash
o2 delete folder 7417863561566760960
o2 delete folder 7417863561566760960 --type dashboards
o2 folder delete 7417863561566760960 --type reports
```

**Flags:**
- `--type <type>` - Folder type: `alerts`, `dashboards`, `reports` (default: "alerts")
- All global flags

**Note:** Requires folder ID. Cannot delete default folders or folders with resources.

---

### `o2 delete function`
**Aliases:** `func`

**Description:** Delete function by name or from file

**Usage:**
```bash
o2 delete function my-function          # By name
o2 delete function -f function.yaml     # From file
o2 function delete my-function          # Alternative
```

**Flags:**
- `[function-name]` - Function name OR
- `-f, --file <path>` - Extract name from file
- All global flags

---

### `o2 delete dashboard <id>`
**Aliases:** `dash`

**Description:** Delete dashboard by ID

**Usage:**
```bash
o2 delete dashboard 7417863561566760960
o2 delete dashboard 7417863561566760960 --folder production
o2 dashboard delete 7417863561566760960         # Alternative
```

**Flags:**
- `<dashboard-id>` - Dashboard ID (required)
- `--folder <name>` - Folder name (default: "default")
- All global flags

**Important:** Dashboard delete requires **dashboard ID** (not file). Get ID from `o2 list dashboard`.

---

## 🔧 Alert-Specific Commands

### `o2 alert enable <name>`

**Description:** Enable a disabled alert

**Usage:**
```bash
o2 alert enable my-alert                       # Enable alert (searches all folders)
o2 alert enable my-alert --folder production   # Enable alert in specific folder
```

**Flags:**
- `--folder <name>` - Folder name (optional, searches all if not specified)
- All global flags

**Note:** For service accounts, folder is required. For user accounts, it will search all folders if not specified.

---

### `o2 alert disable <name>`

**Description:** Disable an enabled alert

**Usage:**
```bash
o2 alert disable my-alert                      # Disable alert (searches all folders)
o2 alert disable my-alert --folder production  # Disable alert in specific folder
```

**Flags:**
- `--folder <name>` - Folder name (optional, searches all if not specified)
- All global flags

**Note:** For service accounts, folder is required. For user accounts, it will search all folders if not specified.

---

## 📚 Resource-Specific Commands

### Template Commands

```bash
# List
o2 list template
o2 template list

# Get
o2 get template StandardAlert
o2 template get StandardAlert --output yaml

# Create
o2 create template -f template.yaml
o2 template create -f template.yaml

# Update (name optional)
o2 update template -f template.yaml
o2 update template MyTemplate -f updated.yaml

# Delete (by name or file)
o2 delete template MyTemplate
o2 delete template -f template.yaml
```

---

### Destination Commands

```bash
# List
o2 list dest
o2 list dest --type http
o2 dest list

# Get
o2 get dest slack-webhook
o2 dest get slack-webhook

# Create
o2 create dest -f destination.yaml
o2 dest create -f destination.yaml

# Update (name optional)
o2 update dest -f destination.yaml
o2 dest update MyDest -f updated.yaml

# Delete (by name or file)
o2 delete dest slack-webhook
o2 delete dest -f destination.yaml
```

---

### Pipeline Commands

```bash
# List
o2 list pipeline
o2 pipeline list

# Get
o2 get pipeline my-pipeline
o2 pipeline get my-pipeline

# Create
o2 create pipeline -f pipeline.yaml
o2 pipeline create -f pipeline.yaml

# Update (name optional)
o2 update pipeline -f pipeline.yaml
o2 pipeline update MyPipeline -f updated.yaml

# Delete (by name or file)
o2 delete pipeline my-pipeline
o2 delete pipeline -f pipeline.yaml
```

---

### Function Commands

```bash
# List
o2 list function
o2 function list

# Get
o2 get function my-function
o2 function get my-function

# Create
o2 create function -f function.yaml
o2 function create -f function.yaml

# Update (name optional)
o2 update function -f function.yaml
o2 function update MyFunc -f updated.yaml

# Delete (by name or file)
o2 delete function my-function
o2 delete function -f function.yaml
```

---

### Folder Commands

```bash
# List
o2 list folder
o2 list folder --type dashboards
o2 folder list --type reports

# Get
o2 get folder ProductionAlerts
o2 get folder 7417863561566760960 --by-id
o2 folder get monitoring --type dashboards

# Create
o2 create folder production-alerts
o2 create folder monitoring --type dashboards --description "Monitoring dashboards"
o2 folder create quarterly --type reports

# Update (requires ID)
o2 update folder 7417863561566760960 --name "New Name"
o2 update folder 7417863561566760960 --description "Updated description"
o2 folder update 7417863561566760960 --name "Prod" --description "Production"

# Delete (requires ID)
o2 delete folder 7417863561566760960
o2 delete folder 7417863561566760960 --type dashboards
o2 folder delete 7417863561566760960 --type reports
```

**Important:**
- Folders are **namespaced by type** - the same name can exist in alerts, dashboards, and reports as separate folders
- Always specify `--type` when working with non-alert folders (default is "alerts")
- When using folder IDs instead of names, you must use the `--by-id` flag
- Service accounts require folders for accessing resources
- Cannot delete default folders or folders with resources
- Update and delete operations require folder ID

---

### Dashboard Commands

```bash
# List
o2 list dashboard --folder production
o2 dashboard list --folder monitoring

# Get (requires ID)
o2 get dashboard 7417863561566760960
o2 dashboard get 7417863561566760960

# Create
o2 create dashboard -f dashboard.yaml
o2 dashboard create -f dashboard.yaml

# Update (requires ID)
o2 update dashboard 7417863561566760960 -f updated.yaml
o2 dashboard update 7417863561566760960 -f updated.yaml

# Delete (requires ID, not file)
o2 delete dashboard 7417863561566760960
o2 dashboard delete 7417863561566760960 --folder production
```

**Important:** Dashboards use **numeric IDs**. Get ID from `o2 list dashboard`.

---

### Organization Commands

```bash
# List
o2 list organizations
o2 organization list

# Get
o2 get organization default
o2 organization get default

# Get summary
o2 get organization default --summary
o2 organization get default --summary

# Create
o2 create organization myorg --identifier myorg
o2 organization create myorg --identifier myorg
```

**Summary Output:**
```
Organization Summary: default
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Streams:    5 (Size: 1048576 bytes)
Functions:  3
Alerts:     2
Dashboards: 4
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Alert Commands

```bash
# List
o2 list alert
o2 list alert --folder default
o2 list alert --enabled-only
o2 alert list --folder ProductionAlerts

# Get
o2 get alert my-alert
o2 alert get my-alert

# Create
o2 create alert -f alert.yaml
o2 alert create -f alert.yaml

# Update (by name or ID, optional if in file)
o2 update alert -f alert.yaml
o2 update alert my-alert -f updated.yaml
o2 update alert 39z0R4KJlK5uyj0it2mmndNP2HC -f updated.yaml
o2 alert update -f alert.yaml

# Delete (by name, ID, or file)
o2 delete alert my-alert
o2 delete alert 39z0R4KJlK5uyj0it2mmndNP2HC
o2 delete alert -f alert.yaml
o2 alert delete my-alert

# Enable/Disable (by name)
o2 alert enable my-alert
o2 alert enable my-alert --folder ProductionAlerts
o2 alert disable my-alert
o2 alert disable my-alert --folder ProductionAlerts
```

**Important:**
- Delete accepts alert **name** (e.g., `my-alert`) or **ID** (e.g., `39z0R4KJlK5uyj0it2mmndNP2HC`)
- Get the name and ID from `o2 list alert`
- Template must exist before creating alert destination

---

## 🎯 Complete Command Matrix

| Resource | List | Get | Create | Update | Delete | Enable/Disable |
|----------|------|-----|--------|--------|--------|----------------|
| Organizations | ✅ | ✅ (+ summary) | ✅ | N/A | N/A | N/A |
| Folders | ✅ | ✅ | ✅ | ✅ (by ID) | ✅ (by ID) | N/A |
| Dashboards | ✅ | ✅ | ✅ | ✅ | ✅ (by ID) | N/A |
| Alerts | ✅ | ✅ | ✅ | ✅ | ✅ (by name/ID) | ✅ |
| Templates | ✅ | ✅ | ✅ | ✅ | ✅ | N/A |
| Destinations | ✅ | ✅ | ✅ | ✅ | ✅ | N/A |
| Pipelines | ✅ | ✅ | ✅ | ✅ | ✅ | N/A |
| Functions | ✅ | ✅ | ✅ | ✅ | ✅ | N/A |

---

## 💡 Usage Tips

### 1. **Get Resource IDs/Names**
Always list first to get exact names/IDs:
```bash
o2 list dashboard --folder production
o2 list template
o2 list pipeline
```

### 2. **Use Profiles**
Configure once, use everywhere:
```bash
o2 configure --profile prod
o2 list template --profile prod
o2 create dest -f dest.yaml --profile prod
```

### 3. **Export and Backup**
```bash
o2 get template StandardAlert -o yaml > backup.yaml
o2 list dashboard --output json > dashboards-backup.json
```

### 4. **Filter Effectively**
```bash
o2 list alert --folder ProductionAlerts --enabled-only
o2 list dest --type http --org myorg
o2 list dashboard --folder monitoring --output wide
```

### 5. **Use Both Syntaxes**
Mix and match as needed:
```bash
o2 list template                    # Verb-first
o2 template create -f template.yaml # Resource-first
o2 delete dest old-dest             # Verb-first
```

### 6. **Service Account vs User Account**
Understanding authentication differences:

**Service Accounts:**
- Use tokens for authentication
- Require folder specification for most operations
- Cannot access report folders
- Limited to programmatic access within assigned folders

**User Accounts:**
- Use passwords for authentication
- Can search across all folders
- Full administrative permissions
- Can access reports and all folder types

Configure appropriately:
```bash
o2 configure --profile prod        # Interactive setup (prompts for account type)
o2 list alert --folder production  # Service accounts need --folder
o2 list alert                      # User accounts can list all
```

---

## 🔍 Finding Commands

**Show all commands:**
```bash
o2 --help
```

**Show verb commands:**
```bash
o2 list --help
o2 create --help
o2 get --help
o2 update --help
o2 delete --help
```

**Show resource commands:**
```bash
o2 template --help
o2 dashboard --help
o2 pipeline --help
o2 function --help
o2 destination --help
```

---

## 📝 Notes

### Delete Operations

**Requires name or file:**
- Templates, Destinations, Pipelines, Functions: `o2 delete <resource> <name>` OR `o2 delete <resource> -f file.yaml`
- **Dashboards: Requires ID only** (not file): `o2 delete dashboard <id>`

Get the dashboard ID from `o2 list dashboard` before deleting.

### Update Operations

**Name optional if in file:**
```bash
o2 update template -f template.yaml          # Extracts name from file
o2 update template MyTemplate -f new.yaml    # Explicit name (can differ)
```

**Dashboard updates require ID:**
```bash
o2 update dashboard <id> -f updated.yaml
```

### YAML Formats

**Simple Format** (Templates, Destinations, Functions):
- Just the resource fields
- No Kubernetes wrapper
- 3-5 lines minimum

**Full K8s Format** (Dashboards, Pipelines, or any resource):
- Complete Kubernetes resource
- Includes apiVersion, kind, metadata, spec
- Compatible with kubectl

**Both formats work!** CLI auto-detects.

---

**For more details, see README.md and samples/ directory**
