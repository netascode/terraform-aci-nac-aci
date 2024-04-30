# Leaf Switch Policy Group

Location in GUI:
`Fabric` » `Fabric Policies` » `Switches` » `Leaf Switches` » `Policy Groups`


{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    leaf_switch_policy_groups:
      - name: ALL_LEAFS
        psu_policy: COMBINED
        node_control_policy: DOM_NETFLOW
```
