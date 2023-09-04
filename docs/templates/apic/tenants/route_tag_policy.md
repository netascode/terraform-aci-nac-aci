# Route Tag Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `Route Tag`

### Terraform modules

* [Route Tag Policy](https://registry.terraform.io/modules/netascode/route-tag-policy/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        route_tag_policies:
          - name: TAG1
            description: "My Tag"
            tag: 112233
```
