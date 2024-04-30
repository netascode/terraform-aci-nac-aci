# OOB Contract

Location in GUI:
`Tenants` » `mgmt` » `Contracts` » `Out-Of-Band Contracts`


{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: mgmt
      oob_contracts:
        - name: OOB-CON1
          subjects:
            - name: OOB-SUB
              filters:
                - filter: ALL
```

Full example:

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
