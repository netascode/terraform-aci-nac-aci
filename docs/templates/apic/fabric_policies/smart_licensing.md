# Smart Licensing

Location in GUI:
`System` » `Smart Licensing`

### Terraform modules

* [Smart Licensing](https://registry.terraform.io/modules/netascode/smart-licensing/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  fabric_policies:
    smart_licensing:
      mode: proxy
      registration_token: ABCDEFG
      proxy:
        hostname_ip: 1.1.1.1
        port: 80
```
