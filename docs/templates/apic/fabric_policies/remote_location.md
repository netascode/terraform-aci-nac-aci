# Remote Location

Location in GUI:
`Admin` » `Import/Export` » `Remote Locations`

### Terraform modules

* [Remote Location](https://registry.terraform.io/modules/netascode/remote-location/aci/latest)

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
