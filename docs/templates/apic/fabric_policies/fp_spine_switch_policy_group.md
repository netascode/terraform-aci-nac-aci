# Spine Switch Policy Group

Location in GUI:
`Fabric` » `Fabric Policies` » `Switches` » `Spine Switches` » `Policy Groups`


{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    spine_switch_policy_groups:
      - name: ALL_SPINES
        psu_policy: COMBINED
        node_control_policy: DOM_NETFLOW
```
