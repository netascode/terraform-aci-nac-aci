# Fabric Leaf Interface Profile

Leaf Interface Profiles can either be auto-generated, one per leaf, by providing a naming convention or can be defined explicitly. In case of auto-generated profiles the following placeholders can be used when defining the naming convention:

* `\\g<id>`: gets replaced by the respective leaf node ID
* `\\g<name>`: gets replaced by the respective leaf hostname

Location in GUI:
`Fabric` » `Fabric Policies` » `Interfaces` » `Leaf Interfaces` » `Profiles`

### Terraform modules

* [Fabric Leaf Interface Profile](https://registry.terraform.io/modules/netascode/fabric-leaf-interface-profile/aci/latest)

{{ doc_gen }}

### Examples

Auto-generate profiles:

```yaml
apic:
  auto_generate_switch_pod_profiles: true
  fabric_policies:
    leaf_interface_profile_name: "LEAF\\g<id>"
```

Explicitly configured profiles:

```yaml
apic:
  fabric_policies:
    leaf_interface_profiles:
      - name: LEAF1001
```
