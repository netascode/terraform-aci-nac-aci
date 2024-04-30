# Fabric Spine Switch Profile

Spine Switch Profiles can either be auto-generated, one per spine, by providing a naming convention or can be defined explicitly. In case of auto-generated profiles the following placeholders can be used when defining the naming convention:

* `\\g<id>`: gets replaced by the respective spine node ID
* `\\g<name>`: gets replaced by the respective spine hostname

Location in GUI:
`Fabric` » `Fabric Policies` » `Switches` » `Spine Switches` » `Profiles`


{{ doc_gen }}

### Examples

```yaml
apic:
  auto_generate_switch_pod_profiles: true
  fabric_policies:
    spine_switch_profile_name: "SPINE\\g<id>"
    spine_switch_selector_name: "SPINE\\g<id>"
```

Explicitly configured profiles:

```yaml
apic:
  fabric_policies:
    spine_switch_profiles:
      - name: SPINE101
        selectors:
          - name: SEL1
            policy: ALL_SPINE
            node_blocks:
              - name: BLOCK1
                from: 101
        interface_profiles:
          - SPINE101
```
