# Maintenance Groups

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  node_policies:
    update_groups:
      - name: MG1
        scheduler: scheduler1
    nodes:
      - id: 101
        update_group: MG1
```
