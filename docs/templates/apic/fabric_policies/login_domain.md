# Login Domain

Location in GUI:
`Admin` » `AAA` » `Authentication` » `AAA`

### Terraform modules

* [Login Domain](https://registry.terraform.io/modules/netascode/login-domain/aci/latest)

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
        - name: ldap
          realm: ldap
          description: login domain ldap
          auth_choice: LdapGroupMap
          ldap_group_map: test-users-map
          ldap_providers:
            - hostname_ip: 2.2.2.2
              priority: 1
```
