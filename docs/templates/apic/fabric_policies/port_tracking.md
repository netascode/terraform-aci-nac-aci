# Port Tracking

Location in GUI:
`System` » `System Settings` » `Port Tracking`

### Terraform modules

* [Port Tracking](https://registry.terraform.io/modules/netascode/port-tracking/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  fabric_policies:
    port_tracking:
      admin_state: 'off'
      delay: 130
      min_links: 1
```
