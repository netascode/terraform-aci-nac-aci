# Service EPG Policy

Description

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
