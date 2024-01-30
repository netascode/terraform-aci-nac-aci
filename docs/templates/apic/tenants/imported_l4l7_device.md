# Imported L4L7 Device

Location in GUI:
`Tenants` » `XXX` » `Services` » `L4-L7` » `Imported Devices`

{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      services:
        imported_l4l7_devices:
          - name: DEV2
            tenant: DEF
```
