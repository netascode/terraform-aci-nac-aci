# Access Spine Interface Selector

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Spine Interfaces` » `Profiles` » `XXX`


{{ doc_gen }}

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
