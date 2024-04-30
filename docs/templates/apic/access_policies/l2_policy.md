# L2 Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `L2 Interface`


{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      l2_policies:
        - name: PORT-LOCAL
          vlan_scope: portlocal
          qinq: disabled
```
