# AAA Settings

Location in GUI:
`Admin` » `AAA` » `Authentication` » `AAA`

### Terraform modules

* [AAA](https://registry.terraform.io/modules/netascode/aaa/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    aaa:
      remote_user_login_policy: no-login
      default_fallback_check: true
      default_realm: local
      console_realm: tacacs
      console_login_domain: tacacs
```
