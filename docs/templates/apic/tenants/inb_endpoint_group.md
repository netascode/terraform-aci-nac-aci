# INB Endpoint Group

Location in GUI:
`Tenants` » `mgmt` » `Node Management EPGs`

### Terraform modules

* [Inband Endpoint Group](https://registry.terraform.io/modules/netascode/inband-endpoint-group/aci/latest)

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
