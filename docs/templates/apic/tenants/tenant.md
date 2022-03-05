# Tenant

Location in GUI:
`Tenants`

### Terraform modules

* [Tenant](https://registry.terraform.io/modules/netascode/tenant/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      alias: ABC-ALIAS
      description: My Description
```
