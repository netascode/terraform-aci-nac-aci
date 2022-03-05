# PIM Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `PIM`

{{ aac_doc }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        pim_policies:
          - name: PIM1
            passive: true
            auth_type: ah-md5
            auth_key: C1sco123
            designated_router_delay: 100
            designated_router_priority: 100
            hello_interval: 100
            join_prune_interval: 60
            join_prune_filter_policy_out: MRM1
            join_prune_filter_policy_in: MRM2
            neighbor_filter_policy: MRM1
```
