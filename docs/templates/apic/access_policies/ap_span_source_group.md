# Access SPAN Source Groups

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Troubleshooting` » `SPAN` » `SPAN Source Groups`

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    span:
      source_groups:
        - name: INT1
          destination:
            name: TAP1
          sources:
            - name: SRC1
              direction: both
              access_paths:
                - node_id: 101
                  port: 1
```
