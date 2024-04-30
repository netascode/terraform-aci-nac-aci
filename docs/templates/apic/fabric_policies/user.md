# User

Location in GUI:
`Admin` » `AAA` » `Users` » `Local Users`


{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  fabric_policies:
    aaa:
      users:
        - username: user1
          password: ciscocisco
          domains:
            - name: all
              roles:
                - name: admin
                  privilege_type: write
            - name: common
```

Full example:

```yaml
apic:
  fabric_policies:
    aaa:
      users:
        - username: user1
          password: ciscocisco
          expires: false
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
