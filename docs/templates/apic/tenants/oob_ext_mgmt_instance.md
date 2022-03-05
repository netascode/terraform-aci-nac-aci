# OOB External Management Instance

Location in GUI:
`Tenants` » `mgmt` » `External Management Network Instance Profiles`

### Terraform modules

* [OOB External Management Instance](https://registry.terraform.io/modules/netascode/oob-external-management-instance/aci/latest)

{{ aac_doc }}

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
