# L2 Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `L2 Interface`

### Terraform modules

* [L2 Policy](https://registry.terraform.io/modules/netascode/l2-policy/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      l2_policies:
        - name: PORT-LOCAL
          vlan_scope: portlocal
          qinq: disabled
```
