# INB Node Address

Location in GUI:
`Tenants` » `mgmt` » `Node Management Addresses` » `Static Node Management Addresses`

### Terraform modules

* [Inband Node Address](https://registry.terraform.io/modules/netascode/inband-node-address/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  node_policies:
    nodes:
      - id: 101
        inb_address: 10.1.1.1/24
        inb_gateway: 10.1.1.254
```
