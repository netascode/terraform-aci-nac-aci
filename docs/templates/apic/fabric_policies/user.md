# User

Location in GUI:
`Admin` » `AAA` » `Users` » `Local Users`

### Terraform modules

* [User](https://registry.terraform.io/modules/netascode/user/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  fabric_policies:
    aaa:
      users:
        - username: user1
          password: ciscocisco
          expires: 'no'
          first_name: cisco
          last_name: cisco
          phone: '1234567'
          email: cisco@cisco.com
          certificate_name: cisco
          description: descr
          status: active
          domains:
            - name: all
              roles:
                - name: admin
                  privilege_type: write
            - name: common
```
