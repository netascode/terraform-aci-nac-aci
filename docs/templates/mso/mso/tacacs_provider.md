# Tacacs Provider

Description

{{ aac_doc }}
### Examples

```yaml
mso:
  tacacs_providers:
    - hostname_ip: 2.2.2.2
      description: Description
      shared_secret: cisco
      port: 49
      protocol: pap
      timeout: 5
      retries: 3
```
