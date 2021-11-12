# Fabric Spine Switch Profile

Location in GUI:
`Fabric` » `Fabric Policies` » `Switches` » `Spine Switches` » `Profiles`

### Terraform modules

* [Fabric Spine Switch Profile](https://registry.terraform.io/modules/netascode/fabric-spine-switch-profile/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  auto_generate_switch_pod_profiles: enabled
  fabric_policies:
    spine_switch_profile_name: "SPINE\\g<id>"
    spine_switch_selector_name: "SPINE\\g<id>"
```
