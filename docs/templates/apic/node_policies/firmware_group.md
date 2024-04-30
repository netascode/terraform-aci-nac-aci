# Firmware Groups

Location in GUI:
`Admin` » `Firmware` » `Nodes`


{{ doc_gen }}

### Examples

```yaml
apic:
  node_policies:
    update_groups:
      - name: MG1
    nodes:
      - id: 101
        update_group: MG1
```
