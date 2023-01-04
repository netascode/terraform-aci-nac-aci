# Global Passphrase

Location in GUI:
`System` » `System Settings` » `Global AES Passphrase Encryption Settings`

### Terraform modules

* [Global Passphrase](https://registry.terraform.io/modules/netascode/global-passphrase/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  fabric_policies:
    global_passphrase: Cisco123!Cisco123!
```
