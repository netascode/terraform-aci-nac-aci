# Imported Contract

Location in GUI:
`Tenants` » `XXX` » `Contracts` » `Imported`

### Terraform modules

* [Imported Contract](https://registry.terraform.io/modules/netascode/imported-contract/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      imported_contracts:
        - name: IMPORT-CON1
          tenant: DEF
          contract: CON1
```
