# Access SPAN Destination Groups

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Troubleshooting` » `SPAN` » `SPAN Destination Groups`

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    span:
      destination_groups:
        - name: TAP1
          description: My_SPAN_Destination
          node_id: 101
          port: 10
```
