# VPC Groups

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Switch` » `Virtual Port Channel default`

### Terraform modules

* [vPC Group](https://registry.terraform.io/modules/netascode/vpc-group/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  node_policies:
    vpc_groups:
      mode: explicit
      groups:
        - id: 101
          switch_1: 101
          switch_2: 102
```
