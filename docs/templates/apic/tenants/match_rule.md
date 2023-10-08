# Match Rule

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `Match Rules`

### Terraform modules

* [Match Rule](https://registry.terraform.io/modules/netascode/match-rule/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        match_rules:
          - name: MATCH1
            description: desc1
            prefixes:
              - ip: 10.0.0.0/8
                description: desc2
                aggregate: true
                from_length: 24
                to_length: 32
```
