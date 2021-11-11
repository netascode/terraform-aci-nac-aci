# Access Leaf Switch Profile

Location in GUI:
`Fabric` » `Access Policies` » `Switches` » `Leaf Switches` » `Profiles`

Terraform modules:

* [Access Leaf Switch Profile](https://github.com/netascode/terraform-aci-access-leaf-switch-profile)

{{ aac_doc }}
### Examples

```yaml
apic:
  auto_generate_switch_pod_profiles: enabled
  access_policies:
    leaf_switch_profile_name: "LEAF\\g<id>"
    leaf_switch_selector_name: "LEAF\\g<id>"
```
