# Node Registration

Location in GUI:
`Fabric` » `Inventory` » `Fabric Membership`


{{ doc_gen }}

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
      - id: 1001
        pod: 1
        role: spine
        set_role: true  # For dual-role switches
        serial_number: ABC1234569
        name: SPINE1001
```
