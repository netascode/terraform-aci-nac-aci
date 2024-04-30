# Access Leaf Interface Profile

Leaf Interface Profiles can either be auto-generated, one per leaf, by providing a naming convention or can be defined explicitly. In case of auto-generated profiles the following placeholders can be used when defining the naming convention:

* `\\g<id>`: gets replaced by the respective leaf node ID
* `\\g<name>`: gets replaced by the respective leaf hostname

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Leaf Interfaces` » `Profiles`


{{ doc_gen }}

### Examples

Auto-generate profiles:

```yaml
apic:
  auto_generate_switch_pod_profiles: true
  access_policies:
    leaf_interface_profile_name: "LEAF\\g<id>"
```

Explicitly configured profiles:

```yaml
apic:
  access_policies:
    leaf_interface_profiles:
      - name: LEAF1001
        selectors:
          - name: SEL1
            policy_group: 10G-SERVER
            port_blocks:
              - name: BLOCK1
                description: Server ABC
                from_port: 1
```
