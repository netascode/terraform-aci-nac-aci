# Access Leaf Interface Profile

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Leaf Interfaces` » `Profiles`

Terraform modules:

* [Access Leaf Interface Profile](https://github.com/netascode/terraform-aci-access-leaf-interface-profile)

{{ aac_doc }}
### Examples

```yaml
apic:
  auto_generate_switch_pod_profiles: enabled
  access_policies:
    leaf_interface_profile_name: "LEAF\\g<id>"
    leaf_interface_selector_name: "ETH\\g<mod>-\\g<port>"
```
