# Access Spine Switch Profile

Location in GUI:
`Fabric` » `Access Policies` » `Switches` » `Spine Switches` » `Profiles`

Terraform modules:

* [Access Spine Switch Profile](https://github.com/netascode/terraform-aci-access-spine-switch-profile)

{{ aac_doc }}
### Examples

```yaml
apic:
  auto_generate_switch_pod_profiles: enabled
  access_policies:
    spine_switch_profile_name: "SPINE\\g<id>"
    spine_switch_selector_name: "SPINE\\g<id>"
```
