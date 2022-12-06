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
    oob_endpoint_group: OOB1
    nodes:
      - id: 101
        pod: 2
        oob_address: 10.1.1.1/24
        oob_gateway: 10.1.1.254
        oob_v6_address: 2001::2/64
        oob_v6_gateway: 2001::1
```
