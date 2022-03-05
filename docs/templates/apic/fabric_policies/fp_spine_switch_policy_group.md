# Spine Switch Policy Group

Location in GUI:
`Fabric` » `Fabric Policies` » `Switches` » `Spine Switches` » `Policy Groups`

### Terraform modules

* [Fabric Spine Switch Policy Group](https://registry.terraform.io/modules/netascode/fabric-spine-switch-policy-group/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  fabric_policies:
    spine_switch_policy_groups:
      - name: ALL_SPINES
        psu_policy: COMBINED
        node_control_policy: DOM_NETFLOW
```
