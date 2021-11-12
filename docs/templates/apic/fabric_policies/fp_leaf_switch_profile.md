# Fabric Leaf Switch Profile

Location in GUI:
`Fabric` » `Fabric Policies` » `Switches` » `Leaf Switches` » `Profiles`

### Terraform modules

* [Fabric Leaf Switch Profile](https://registry.terraform.io/modules/netascode/fabric-leaf-switch-profile/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  auto_generate_switch_pod_profiles: enabled
  fabric_policies:
    leaf_switch_profile_name: "LEAF\\g<id>"
    leaf_switch_selector_name: "LEAF\\g<id>"
```
