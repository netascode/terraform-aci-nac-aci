# Element Types

## `dict`

An element of type `dict` will create a dictionary in the output YAML file with its child elements becoming keys (attributes).

Example:

```yaml
---
files:
  - name: access_policies.yaml
    elements:
      - name: apic
        type: dict
        elements:
          - name: access_policies
            type: dict
...
```

Output file `access_policies.yaml`:

```yaml
---
apic:
  access_policies:
...
```
