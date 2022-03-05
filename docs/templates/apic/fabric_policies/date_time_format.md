# Date and Time Format

Location in GUI:
`System` » `System Settings` » `Date and Time`

### Terraform modules

* [Date Time Format](https://registry.terraform.io/modules/netascode/date-time-format/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  fabric_policies:
    date_time_format:
      display_format: local
      timezone: p0_UTC
      show_offset: true
```
