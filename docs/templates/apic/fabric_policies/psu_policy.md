# PSU Switch Policy

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Switch` » `Power Supply Redundancy`


{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    switch_policies:
      psu_policies:
        - name: COMBINED
          admin_state: combined
```
