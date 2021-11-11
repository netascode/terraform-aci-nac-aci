# Login Domain

Description

{{ aac_doc }}
### Examples

```yaml
mso:
  login_domains:
    - name: TACACS1
      description: Description
      realm: tacacs
      status: active
      default: false
      providers:
        - hostname_ip: 2.2.2.2
          priority: 2
```
