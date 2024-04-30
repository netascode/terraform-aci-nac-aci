# OOB Endpoint Group

Location in GUI:
`Tenants` » `mgmt` » `Node Manangement EPGs`


{{ doc_gen }}

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
