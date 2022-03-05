# Access FEX Interface Selector

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Leaf Interfaces` » `Profiles` » `XXX`

### Terraform modules

* [Access FEX Interface Selector](https://registry.terraform.io/modules/netascode/access-fex-interface-selector/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  interface_policies:
    nodes:
      - id: 101
        fexes:
          - id: 101
            interfaces:
              - port: 1
                description: interface descr
                policy_group: ACC1
```
