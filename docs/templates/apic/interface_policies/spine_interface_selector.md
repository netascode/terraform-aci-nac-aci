# Access Spine Interface Selector

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Spine Interfaces` » `Profiles` » `XXX`

### Terraform modules

* [Access Spine Interface Selector](https://registry.terraform.io/modules/netascode/access-spine-interface-selector/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  interface_policies:
    nodes:
      - id: 1001
        interfaces:
          - port: 60
            policy_group: IPN
```
