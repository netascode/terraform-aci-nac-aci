# Access FEX Interface Selector

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Leaf Interfaces` » `Profiles` » `XXX`


{{ doc_gen }}

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
