# Login Domain

This is only supported for VM and ASE (Application Service Engine) based deployments. Deployments based on Nexus Dashboard do not support this feature.

Location in GUI:
`Admin` » `Authentication` » `Login Domains`

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
