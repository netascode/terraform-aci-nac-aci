# Track Member

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `IP SLA` » `Track Members`

{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        track_members:
          - name: TRACK_MEM1
            destination_ip: 10.2.3.4
            scope_type: l3out
            scope: L3OUT1
            ip_sla_policy: EXAMPLE
```
