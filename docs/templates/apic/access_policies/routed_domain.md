# Routed Domain

Location in GUI:
`Fabric` » `Access Policies` » `Physical and External Domains` » `L3 Domains`

### Terraform modules

* [Routed Domain](https://registry.terraform.io/modules/netascode/routed-domain/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    routed_domains:
      - name: ROUTED1
        vlan_pool: ROUTED1
```
