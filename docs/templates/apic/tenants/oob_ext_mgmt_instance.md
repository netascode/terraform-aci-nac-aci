# OOB External Management Instance

Location in GUI:
`Tenants` » `mgmt` » `External Management Network Instance Profiles`


{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: mgmt
      ext_mgmt_instances:
        - name: EXT1
          subnets:
            - 0.0.0.0/0
          oob_contracts:
            consumers:
              - OOB-CON1
```
