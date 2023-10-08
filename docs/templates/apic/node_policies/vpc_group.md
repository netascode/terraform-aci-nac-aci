# VPC Groups

vPC groups can be named according to a naming convention defined once, without having to specify a name for every group. The following placeholders can be used when defining the naming convention:

* `\\g<switch1_id>`: gets replaced by the respective node ID of the first leaf
* `\\g<switch2_id>`: gets replaced by the respective node ID of the second leaf

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Switch` » `Virtual Port Channel default`

### Terraform modules

* [vPC Group](https://registry.terraform.io/modules/netascode/vpc-group/aci/latest)

{{ doc_gen }}

### Examples

vPC groups:

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

vPC group naming convention:

```yaml
apic:
  access_policies:
    vpc_group_name: "VPC\\_g<switch1_id>_\\g<switch2_id>"
```
