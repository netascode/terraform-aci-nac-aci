# BGP Address Family Context Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BGP` » `BGP Address Family Context`

{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        bgp_address_family_context_policies:
          - name: BGP-AFC1
            ebgp_distance: 30
            ibgp_distance: 210
            local_distance: 230
            ebgp_max_ecmp: 64
            ibgp_max_ecmp: 64
            local_max_ecmp: 16
            enable_host_route_leak: true
```
