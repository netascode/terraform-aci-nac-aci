# Tenant SPAN Source Group

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Troubleshooting` » `SPAN` » `SPAN Source Groups`

{{ aac_doc }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        span:
          source_groups:
            - name: SRC_GRP1
              description: My Source Group
              sources:
                - name: SRC1
                  description: My source
                  direction: in
                  application_profile: AP1
                  endpoint_group: EPG1
```
