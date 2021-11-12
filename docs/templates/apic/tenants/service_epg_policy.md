# Service EPG Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `L4-L7 Service EPG Policy`

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      services:
        service_epg_policies:
          - name: SERVICE_EPG1
            description: My Desc
            preferred_group: include
          - name: SERVICE_EPG2
```
