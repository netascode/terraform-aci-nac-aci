# Firmware Groups

Location in GUI:
`Admin` » `Firmware` » `Nodes`

### Terraform modules

* [Firmware Group](https://registry.terraform.io/modules/netascode/firmware-group/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  node_policies:
    update_groups:
      - name: MG1
    nodes:
      - id: 101
        update_group: MG1
```
