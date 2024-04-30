# AAA Settings

Location in GUI:
`Admin` » `AAA` » `Authentication` » `AAA`


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
        password_strength_profile:
          password_mininum_length: 8
          password_maximum_length: 64
          password_strength_test_type: default
          password_class_flags:
            - digits
            - lowercase
            - uppercase
        password_change_during_interval: true
        password_change_count: 2
        password_change_interval: 48
        password_no_change_interval: 24
        password_history_count: 5
        web_token_timeout: 600
        web_token_max_validity: 24
        web_session_idle_timeout: 1200
        include_refresh_session_records: true
        enable_login_block: false
        login_block_duration: 60
        login_max_failed_attempts: 5
        login_max_failed_attempts_window: 5
```
