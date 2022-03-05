# OOB Endpoint Group

Location in GUI:
`Tenants` » `mgmt` » `Node Manangement EPGs`

### Terraform modules

* [OOB Endpoint Group](https://registry.terraform.io/modules/netascode/oob-endpoint-group/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  tenants:
    - name: mgmt
      oob_endpoint_groups:
        - name: OOB
          oob_contracts:
            providers:
              - OOB-CON1
```
