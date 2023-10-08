# Config Exports

Location in GUI:
`Admin` » `Import/Export` » `Export Policies` » `Configuration`

### Terraform modules

* [Config Export](https://registry.terraform.io/modules/netascode/config-export/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    config_exports:
      - name: export1
        description: desc1
        format: xml
        remote_location: remote1
        scheduler: scheduler1
```
