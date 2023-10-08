# Fabric Spine Interface Profile

Spine Interface Profiles can either be auto-generated, one per spine, by providing a naming convention or can be defined explicitly. In case of auto-generated profiles the following placeholders can be used when defining the naming convention:

* `\\g<id>`: gets replaced by the respective spine node ID
* `\\g<name>`: gets replaced by the respective spine hostname

Location in GUI:
`Fabric` » `Fabric Policies` » `Interfaces` » `Spine Interfaces` » `Profiles`

### Terraform modules

* [Fabric Spine Interface Profile](https://registry.terraform.io/modules/netascode/fabric-spine-interface-profile/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  auto_generate_switch_pod_profiles: true
  fabric_policies:
    spine_interface_profile_name: "SPINE\\g<id>"
```

Explicitly configured profiles:

```yaml
apic:
  fabric_policies:
    spine_interface_profiles:
      - name: SPINE101
```
