# Access Spine Switch Policy Group

Location in GUI:
`Fabric` » `Access Policies` » `Switches` » `Spine Switches` » `Policy Groups`

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    spine_switch_policy_groups:
      - name: SPINE-PG1
        lldp_policy: LLDP-ON
```
