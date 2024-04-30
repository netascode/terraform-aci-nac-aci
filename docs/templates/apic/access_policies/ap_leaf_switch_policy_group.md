# Access Leaf Switch Policy Group

Location in GUI:
`Fabric` » `Access Policies` » `Switches` » `Leaf Switches` » `Policy Groups`


{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    leaf_switch_policy_groups:
      - name: ALL_LEAFS
        forwarding_scale_policy: HIGH-DUAL-STACK
```
