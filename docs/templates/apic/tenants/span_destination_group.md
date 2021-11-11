# Tenant SPAN Destination Group

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        span:
          destination_groups:
            - name: DST_GRP1
              ip: 1.1.1.1
              source_prefix: 2.2.2.2/32
              tenant: DEF
              application_profile: AP1
              endpoint_group: EPG1
```
