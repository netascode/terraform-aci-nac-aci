# User

This is only supported for VM and ASE (Application Service Engine) based deployments. Deployments based on Nexus Dashboard do not support this feature.

Location in GUI:
`Admin` » `Users`

{{ aac_doc }}
### Examples

```yaml
mso:
  users:
    - username: USER1
      password: Cisco123456!
      first_name: first
      last_name: last
      email_address: aa.aa@aa.aa
      phone_number: '12345678910'
      status: active
      roles:
        - role: powerUser
          access: readWrite
```
