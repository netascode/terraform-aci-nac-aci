# Set Rule

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `Set Rules`


{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        set_rules:
          - name: SET1
            description: desc1
            community_mode: replace
            community: regular:as2-nn2:12:123
```
