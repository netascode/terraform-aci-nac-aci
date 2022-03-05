# Access Leaf Switch Profile

Leaf Switch Profiles can either be auto-generated, one per leaf, by providing a naming convention or can be defined explicitly. In case of auto-generated profiles the following placeholders can be used when defining the naming convention:

* `\\g<id>`: gets replaced by the respective leaf node ID
* `\\g<name>`: gets replaced by the respective leaf hostname

Location in GUI:
`Fabric` » `Access Policies` » `Switches` » `Leaf Switches` » `Profiles`

### Terraform modules

* [Access Leaf Switch Profile](https://registry.terraform.io/modules/netascode/access-leaf-switch-profile/aci/latest)

{{ aac_doc }}

### Examples

Auto-generate profiles:

```yaml
apic:
  auto_generate_switch_pod_profiles: true
  access_policies:
    leaf_switch_profile_name: "LEAF\\g<id>"
    leaf_switch_selector_name: "LEAF\\g<id>"
```

Explicitly configured profiles:

```yaml
apic:
  access_policies:
    leaf_switch_profiles:
      - name: LEAF1001
        selectors:
          - name: SEL1
            policy: ALL_LEAFS
            node_blocks:
              - name: BLOCK1
                from: 1001
        interface_profiles:
          - LEAF1001
```
