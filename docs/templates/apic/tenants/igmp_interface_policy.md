# IGMP Interface Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `IGMP Interface`

{{ aac_doc }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        igmp_interface_policies:
          - name: IGMP-IF1
            report_policy_multicast_route_map: MRM1
            static_report_multicast_route_map: MRM2
```
