# Filter

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      filters:
        - name: FILTER1
          alias: ABC-FILTER1
          description: My Desc
          entries:
            - name: HTTP1
              alias: HTTP1-ALIAS
              ethertype: ip
              protocol: tcp
              source_from_port: 80
              source_to_port: 80
              destination_from_port: 80
              destination_to_port: 80
              stateful: 'yes'
```
