# Access FEX Interface Profile

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Leaf Interfaces` » `Profiles`

Terraform modules:

* [Access FEX Interface Profile](https://github.com/netascode/terraform-aci-access-fex-interface-profile)

{{ aac_doc }}
### Examples

```yaml
apic:
  auto_generate_switch_pod_profiles: enabled
  access_policies:
    fex_profile_name: "LEAF\\g<id>-FEX\\g<fex>"
    fex_interface_selector_name: "ETH\\g<mod>-\\g<port>"
```
