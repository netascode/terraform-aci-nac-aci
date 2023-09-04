# LDAP 

Location in GUI:
`Admin` » `AAA` » `Authentication` » `LDAP`

### Terraform modules

* [LDAP](https://registry.terraform.io/modules/netascode/ldap/aci/latest)

{{ aac_doc }}

### Examples

Simple example:

```yaml
apic:
  fabric_policies:
    aaa:
      ldap:
        providers:
          - hostname_ip: 2.2.2.2
            bind_dn: CN=testuser,OU=Employees,DC=example,DC=com
            base_dn: OU=Employees,DC=example,DC=com
            password: test@1234
            attribute: memberOf
        group_map_rules:
          - name: test-users-rules
            group_dn: CN=test-users,DC=example,DC=com
            security_domains:
              - name: all
                roles:
                  - name: admin
        group_maps:
          - name: test-users-map
            rules:
              - name: test-users-rules
```

Full example:

```yaml
apic:
  fabric_policies:
    aaa:
      ldap:
        providers:
          - hostname_ip: 2.2.2.2
            description: descr
            port: 3389
            bind_dn: CN=testuser,OU=Employees,DC=example,DC=com
            base_dn: OU=Employees,DC=example,DC=com
            password: test@1234
            timeout: 10
            retries: 4
            enable_ssl: true 
            filter: cn=$userid
            attribute: memberOf
            ssl_validation_level: permissive
            mgmt_epg: oob
            server_monitoring: true 
            monitoring_username: user1
            monitoring_password: pass1
          - hostname_ip: 2.2.2.3
        group_map_rules:
          - name: test-users-rules
            description: descr
            group_dn: CN=test-users,DC=example,DC=com
            security_domains:
              - name: all
                roles:
                  - name: admin
                    privilege_type: write
              - name: common
        group_maps:
          - name: test-users-map
            rules:
              - name: test-users-rules
```
