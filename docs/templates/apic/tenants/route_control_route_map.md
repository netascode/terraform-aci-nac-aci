# Route Control Route Map

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `Route Maps for Route Control`

{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        route_control_route_maps:
          - name: ROUTE_MAP1
            type: combinable
            contexts:
              - name: PERMIT
                action: 'permit'
                order: 1
                match_rules:
                  - MATCH1
                  - MATCH2
                set_rule: SET1
```
