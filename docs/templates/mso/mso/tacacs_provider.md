# Tacacs Provider

This is only supported for VM and ASE (Application Service Engine) based deployments. Deployments based on Nexus Dashboard do not support this feature.

Location in GUI:
`Admin` » `Authentication` » `Providers` » `Global`

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
