# Access Spine Interface Policy Group

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Spine Interfaces` » `Policy Groups`

Terraform modules:

* [Access Spine Interface Policy Group](https://github.com/netascode/terraform-aci-access-spine-interface-policy-group)

{{ aac_doc }}
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
