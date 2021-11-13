# Access Spine Interface Profile

Spine Interface Profiles can either be auto-generated, one per spine, by providing a naming convention or can be defined explicitly. In case of auto-generated profiles the following placeholders can be used when defining the naming convention:

* `\\g<id>`: gets replaced by the respective spine node ID
* `\\g<name>`: gets replaced by the respective spine hostname

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Spine Interfaces` » `Profiles`

### Terraform modules

* [Access Spine Interface Profile](https://registry.terraform.io/modules/netascode/access-spine-interface-profile/aci/latest)

{{ aac_doc }}
### Examples

Auto-generate profiles:

```yaml
apic:
  auto_generate_switch_pod_profiles: enabled
  access_policies:
    spine_interface_profile_name: "SPINE\\g<id>"
```

Explicitly configured profiles:

```yaml
apic:
  access_policies:
    spine_interface_profiles:
      - name: SPINE101
        selectors:
          - name: SEL1
            policy_group: IPN
            port_blocks:
              - name: BLOCK1
                description: IPN1
                from_port: 1
```
