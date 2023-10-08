# Physical Domain

Location in GUI:
`Fabric` » `Access Policies` » `Physical and External Domains` » `Physical Domains`

### Terraform modules

* [Physical Domain](https://registry.terraform.io/modules/netascode/physical-domain/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    physical_domains:
      - name: PHY1
        vlan_pool: STATIC1
```
