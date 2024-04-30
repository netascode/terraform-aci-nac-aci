# Access Spine Interface Policy Group

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Spine Interfaces` » `Policy Groups`


{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    spine_interface_policy_groups:
      - name: IPN1
        link_level_policy: 10G
        cdp_policy: CDP-ENABLED
        aaep: AAEP1
```
