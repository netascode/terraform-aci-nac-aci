# IGMP Snooping Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `IGMP Snoop`

{{ aac_doc }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        igmp_snooping_policies:
          - name: IGMP-SNOOP1
            fast_leave: true
            querier: true
```
