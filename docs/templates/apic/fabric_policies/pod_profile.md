# Fabric Pod Profile

Location in GUI:
`Fabric` » `Fabric Policies` » `Pods` » `Profiles`

### Terraform modules

* [Fabric Pod Profile](https://registry.terraform.io/modules/netascode/fabric-pod-profile/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  auto_generate_switch_pod_profiles: enabled
  fabric_policies:
    pod_profile_name: "POD\\g<id>"
    pod_profile_pod_selector_name: "POD\\g<id>"
```
