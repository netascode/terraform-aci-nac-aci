# BGP Best Path Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BGP` » `BGP Best Path Policy`

{{ aac_doc }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        bgp_best_path_policies:
          - name: BGP-BEST-PATH1
            control_type: multi-path-relax
```
