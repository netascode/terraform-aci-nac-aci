# Management Access Policy

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  fabric_policies:
    pod_policies:
      management_access_policies:
        - name: MGMT1
          telnet:
            admin_state: enabled
          ssh:
            port: 22
            hmac_sha1: 'no'
            chacha: 'no'
          https:
            tlsv1: 'yes'
          http:
            admin_state: enabled
            port: 8080
```
