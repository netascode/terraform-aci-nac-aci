# INB Node Address

Location in GUI:
`Tenants` » `mgmt` » `Node Management Addresses` » `Static Node Management Addresses`


{{ doc_gen }}

### Examples

```yaml
apic:
  node_policies:
    inb_endpoint_group: INB1
    nodes:
      - id: 101
        inb_address: 10.1.1.1/24
        inb_gateway: 10.1.1.254
        inb_v6_address: 2001::2/64
        inb_v6_gateway: 2001::1
```
