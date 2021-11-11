# Access Spine Interface Profile

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Spine Interfaces` » `Profiles`

Terraform modules:

* [Access Spine Interface Profile](https://github.com/netascode/terraform-aci-access-spine-interface-profile)

{{ aac_doc }}
### Examples

```yaml
apic:
  auto_generate_switch_pod_profiles: enabled
  access_policies:
    spine_interface_profile_name: "SPINE\\g<id>"
    spine_interface_selector_name: "ETH\\g<mod>-\\g<port>"
```
