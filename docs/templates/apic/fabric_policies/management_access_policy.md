# Management Access Policy

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Pod` » `Management Access`

### Terraform modules

* [Management Access policy](https://registry.terraform.io/modules/netascode/management-access-policy/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    pod_policies:
      management_access_policies:
        - name: MGMT1
          telnet:
            admin_state: true
          ssh:
            port: 22
            hmac_sha1: false
            chacha: false
          https:
            tlsv1: true
          http:
            admin_state: true
            port: 8080
```
