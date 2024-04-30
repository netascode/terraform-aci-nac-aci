# INB Endpoint Group

Location in GUI:
`Tenants` » `mgmt` » `Node Management EPGs`


{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: mgmt
      inb_endpoint_groups:
        - name: INB
          vlan: 2
          bridge_domain: inb
          contracts:
            consumers:
              - STD-CON1
            providers:
              - STD-CON1
```
