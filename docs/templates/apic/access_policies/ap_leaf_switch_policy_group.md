# Access Leaf Switch Policy Group

Location in GUI:
`Fabric` » `Access Policies` » `Switches` » `Leaf Switches` » `Policy Groups`

### Terraform modules

* [Access Leaf Switch Policy Group](https://registry.terraform.io/modules/netascode/access-leaf-switch-policy-group/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    leaf_switch_policy_groups:
      - name: ALL_LEAFS
        forwarding_scale_policy: HIGH-DUAL-STACK
```
