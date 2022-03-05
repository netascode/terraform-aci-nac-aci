# IP SLA Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `IP SLA` » `IP SLA Monitoring Policies`

{{ aac_doc }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        ip_sla_policies:
          - name: SLA
            frequency: 10
            multiplier: 10
            sla_type: tcp
            port: 150
```
