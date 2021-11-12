# Set Rule

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `Set Rules`

### Terraform modules

* [Set Rule](https://registry.terraform.io/modules/netascode/set-rule/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        set_rules:
          - name: SET1
            description: desc1
            community_mode: replace
            community: regular:as2-nn2:12:123
```
