# Fabric Link Level Interface Policy

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Interface` » `Link Level`


{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    interface_policies:
      link_level_policies:
        - name: link-level-policy1
          description: Fabric Link Level Policy
          link_debounce_interval: 100
```
