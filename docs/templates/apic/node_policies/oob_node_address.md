# OOB Node Address

Location in GUI:
`Tenants` » `mgmt` » `Node Management Addresses` » `Static Node Management Addresses`

### Terraform modules

* [OOB Node Address](https://registry.terraform.io/modules/netascode/oob-node-address/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  node_policies:
    nodes:
      - id: 101
        oob_address: 10.1.1.1/24
        oob_gateway: 10.1.1.254
```
