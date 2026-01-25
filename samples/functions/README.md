# O2 CLI - Function Samples

Sample VRL function configurations for O2 CLI.

## 📋 Simple YAML Format

```yaml
name: "function-name"    # Required: Function name
function: |              # Required: VRL code
  # Your VRL transformation code
  .
```

**That's it!** Just 2 fields.

## 📁 Available Samples

**1. simple-parse-json.yaml**
Parse JSON from a log field.

**2. simple-geoip-enrichment.yaml**
Enrich logs with GeoIP data.

**3. simple-filter-sensitive.yaml**
Remove sensitive fields from logs.

## 💡 Function Commands

### List Functions
```bash
# List all functions
o2 list function
o2 function list

# Different output formats
o2 list function --output json
o2 list function --output yaml
o2 list function --output wide
```

### Get Function Details
```bash
# Get specific function by name
o2 get function my-function
o2 function get my-function

# Export to YAML
o2 get function my-function --output yaml
```

### Create Function
```bash
# Create from file
o2 create function -f function.yaml
o2 function create -f function.yaml
```

### Update Function
```bash
# Update from file (auto-extracts name from file)
o2 update function -f function.yaml
o2 function update -f function.yaml

# Update with explicit name (can differ from file)
o2 update function MyFunction -f updated.yaml
```

### Delete Function
```bash
# Delete by name
o2 delete function my-function
o2 function delete my-function

# Delete from file (extracts name from file)
o2 delete function -f function.yaml
```

### Test Function
```bash
# Test function with sample data
o2 function test my-function
```

## 🎯 Complete Workflow Example

```bash
# 1. Create a function
o2 create function -f simple-parse-json.yaml

# 2. List to verify
o2 list function

# 3. Get details
o2 get function parse-json

# 4. Test the function
o2 function test parse-json

# 5. Update VRL code
o2 update function -f simple-parse-json.yaml

# 6. Delete when done
o2 delete function parse-json
```

## 📝 VRL Tips

**Infallible operations:** Use `!` for operations that can't fail:
```vrl
. = merge!(., parsed)    # ✅ Infallible
. = merge(., parsed)     # ❌ Fallible - causes error
```

**Error handling:**
```vrl
result, err = parse_json(.message)
if err == null {
  . = merge!(., result)
}
```

**Learn VRL:** https://vrl.dev

## 🔗 More Information

- See [COMMANDS.md](../../docs/COMMANDS.md) for complete command reference
- [VRL Documentation](https://vrl.dev) for VRL language reference
- See [Pipelines](../pipelines/README.md) for using functions in pipelines
