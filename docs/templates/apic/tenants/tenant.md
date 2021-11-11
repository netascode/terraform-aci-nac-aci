# Tenant

Location in GUI:
`Tenants`

Terraform modules:

* [Tenant](https://github.com/netascode/terraform-aci-tenant)

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      alias: ABC-ALIAS
      description: My Description
```
