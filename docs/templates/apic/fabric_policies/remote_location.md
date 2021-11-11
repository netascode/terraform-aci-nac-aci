# Remote Location

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  fabric_policies:
    remote_locations:
      - name: remote1
        description: desc1
        hostname_ip: 1.2.3.4
        protocol: scp
        path: '/path'
        port: 22
        auth_type: password
        username: cisco
        password: cisco
        mgmt_epg: inb
```
