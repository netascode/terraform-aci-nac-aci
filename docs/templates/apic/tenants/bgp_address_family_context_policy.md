# BGP Address Family Context Policy

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        bgp_address_family_context_policies:
          - name: BGP-AFC1
            ebgp_distance: 201
            ibgp_distance: 20
            local_distance: 22
            ebgp_max_ecmp: 18
            ibgp_max_ecmp: 19
            enable_host_route_leak: 'yes'
```
