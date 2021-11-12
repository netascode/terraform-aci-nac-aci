# Redirect Health Group

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `L4-L6 Redirect Health Groups`

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      services:
        redirect_health_groups:
          - name: HEALTH_GROUP1
            description: My Desc
```
