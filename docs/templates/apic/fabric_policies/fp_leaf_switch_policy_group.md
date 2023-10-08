# Leaf Switch Policy Group

Location in GUI:
`Fabric` » `Fabric Policies` » `Switches` » `Leaf Switches` » `Policy Groups`

### Terraform modules

* [Fabric Leaf Switch Policy Group](https://registry.terraform.io/modules/netascode/fabric-leaf-switch-policy-group/aci/latest)

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
