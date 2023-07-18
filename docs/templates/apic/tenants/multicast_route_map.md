# Multicast Route Map

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `Route Maps for Multicast`

{{ aac_doc }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        multicast_route_maps:
          - name: MRM1
            entries:
              - order: 1
                source_ip: 1.2.3.4/32
                group_ip: 224.0.0.0/8
                rp_ip: 3.4.5.6
                action: permit
```
