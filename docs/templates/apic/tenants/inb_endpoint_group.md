# INB Endpoint Group

Description

{{ aac_doc }}
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
