# Maintenance Groups

Location in GUI:
`Admin` » `Firmware` » `Nodes`


{{ doc_gen }}

### Examples

```yaml
apic:
  node_policies:
    update_groups:
      - name: MG1
        scheduler: scheduler1
        target_version: n9000-16.0(1j)
    nodes:
      - id: 101
        update_group: MG1
```
