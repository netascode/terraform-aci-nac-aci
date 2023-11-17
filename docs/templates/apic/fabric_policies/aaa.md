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
      security_domains:
        - name: SEC1
          restricted_rbac_domain: true
      management_settings:
        password_strength_check: true
        web_token_timeout: 600
        web_token_max_validity: 24
        web_session_idle_timeout: 1200
```
