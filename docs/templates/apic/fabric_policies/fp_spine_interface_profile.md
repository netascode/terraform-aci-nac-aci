# Fabric Spine Interface Profile

Location in GUI:
`Fabric` » `Fabric Policies` » `Interfaces` » `Spine Interfaces` » `Profiles`

### Terraform modules

* [Fabric Spine Interface Profile](https://registry.terraform.io/modules/netascode/fabric-spine-interface-profile/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  auto_generate_switch_pod_profiles: enabled
  fabric_policies:
    spine_interface_profile_name: "SPINE\\g<id>"
```
