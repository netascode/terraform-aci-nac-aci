# Node Registration

Location in GUI:
`Fabric` » `Inventory` » `Fabric Membership`

### Terraform modules

* [Node Registration](https://registry.terraform.io/modules/netascode/node-registration/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  node_policies:
    nodes:
      - id: 101
        pod: 1
        role: leaf
        serial_number: ABC1234567
        name: LEAF101
      - id: 3101
        pod: 1
        role: leaf
        type: remote-leaf-wan
        serial-number: ABC1234568
        name: RLEAF3101
```
