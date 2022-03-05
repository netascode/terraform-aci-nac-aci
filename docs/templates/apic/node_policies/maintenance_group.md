# Maintenance Groups

Location in GUI:
`Admin` » `Firmware` » `Nodes`

### Terraform modules

* [Maintenance Group](https://registry.terraform.io/modules/netascode/maintenance-group/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  node_policies:
    update_groups:
      - name: MG1
        scheduler: scheduler1
    nodes:
      - id: 101
        update_group: MG1
```
