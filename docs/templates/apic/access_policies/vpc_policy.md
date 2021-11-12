# vPC Switch Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Switch` » `VPC Domain`

### Terraform modules

* [vPC Policy](https://registry.terraform.io/modules/netascode/vpc-policy/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  access_policies:
    switch_policies:
      vpc_policies:
        - name: VPC300
          peer_dead_interval: 300
```
