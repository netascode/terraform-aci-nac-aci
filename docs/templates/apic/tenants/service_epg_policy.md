# Service EPG Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `L4-L7 Service EPG Policy`

{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      services:
        service_epg_policies:
          - name: SERVICE_EPG1
            description: My Desc
            preferred_group: true
          - name: SERVICE_EPG2
```
