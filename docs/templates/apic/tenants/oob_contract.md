# OOB Contract

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: mgmt
      oob_contracts:
        - name: OOB-CON1
          alias: OOB-CON1-ALIAS
          description: My Desc
          scope: context
          subjects:
            - name: OOB-SUB
              alias: OOB-SUB-ALIAS
              description: My Desc
              filters:
                - filter: ALL
```
