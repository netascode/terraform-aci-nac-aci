# Access Leaf Switch Policy Group

Location in GUI:
`Fabric` » `Access Policies` » `Switches` » `Leaf Switches` » `Policy Groups`

Terraform modules:

* [Access Leaf Switch Policy Group](https://github.com/netascode/terraform-aci-access-leaf-switch-policy-group)

{{ aac_doc }}
### Examples

```yaml
apic:
  access_policies:
    leaf_switch_policy_groups:
      - name: ALL_LEAFS
        forwarding_scale_policy: HIGH-DUAL-STACK
```
