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

## 💡 Commands

### Create
```bash
o2 function create -f function.yaml
o2 create function -f function.yaml     # kubectl-style
```

### List
```bash
o2 function list
o2 list function
```

### Get
```bash
o2 function get my-function
o2 get function my-function
```

### Update
```bash
o2 function update -f function.yaml
o2 update function -f function.yaml
```

### Delete
```bash
o2 function delete my-function
o2 delete function my-function
o2 delete function -f function.yaml
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

- [Operator Function Samples](../../../o2-k8s-operator/samples/functions/)
- [VRL Documentation](https://vrl.dev)
- [O2 CLI Commands](../../O2_CLI_COMMANDS.md)
