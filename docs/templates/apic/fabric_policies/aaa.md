# AAA Settings

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  fabric_policies:
    aaa:
      remote_user_login_policy: no-login
      default_fallback_check: enabled
      default_realm: local
      console_realm: tacacs
      console_login_domain: tacacs
```
