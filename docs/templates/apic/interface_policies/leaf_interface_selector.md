# Access Leaf Interface Selector

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Leaf Interfaces` » `Profiles` » `XXX`


{{ doc_gen }}

### Examples

```yaml
apic:
  interface_policies:
    nodes:
      - id: 101
        interfaces:
          - port: 1
            description: interface descr 1
            policy_group: ACC1
```
