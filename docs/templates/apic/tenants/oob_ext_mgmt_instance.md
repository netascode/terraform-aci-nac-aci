# OOB External Management Instance

Description

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
