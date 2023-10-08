# Fabric SPAN Source Group

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Troubleshooting` » `SPAN` » `SPAN Source Groups`

{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    span:
      source_groups:
        - name: INT1
          destination:
            name: TAP1
          sources:
            - name: SRC1
              tenant: AP1
              vrf: VRF1
              fabric_paths:
                - node_id: 101
                  port: 1
```
