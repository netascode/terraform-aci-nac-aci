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

#### Set AS Path

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
            set_as_paths:
              - criteria: "prepend"
                asns:
                  - number: 65098
                    order: 1
                  - number: 65098
                    order: 2
                  - number: 65098
                    order: 3
              - criteria: "prepend-last-as"
                count: 8
```
