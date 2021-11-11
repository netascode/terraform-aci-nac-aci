# Match Rule

Description

{{ aac_doc }}
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
                aggregate: 'yes'
                from_length: 24
                to_length: 32
```
