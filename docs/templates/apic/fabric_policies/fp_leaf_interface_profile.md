# Fabric Leaf Interface Profile

Location in GUI:
`Fabric` » `Fabric Policies` » `Interfaces` » `Leaf Interfaces` » `Profiles`

### Terraform modules

* [Fabric Leaf Interface Profile](https://registry.terraform.io/modules/netascode/fabric-leaf-interface-profile/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  auto_generate_switch_pod_profiles: enabled
  fabric_policies:
    leaf_interface_profile_name: "LEAF\\g<id>"
```
