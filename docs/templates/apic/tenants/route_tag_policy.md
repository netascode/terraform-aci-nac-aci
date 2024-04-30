# Route Tag Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `Route Tag`


{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        route_tag_policies:
          - name: TAG1
            description: "My Tag"
            tag: 112233
```
