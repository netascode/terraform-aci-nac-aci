# Login Domain

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  fabric_policies:
    aaa:
      login_domains:
        - name: tacacs
          realm: tacacs
          description: login domain tacacs
          tacacs_providers:
            - hostname_ip: 1.1.1.1
              priority: 1
```
