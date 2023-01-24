# PTP

Location in GUI:
`System` » `System Settings` » `PTP and Latency Measurement`

### Terraform modules

* [PTP](https://registry.terraform.io/modules/netascode/ptp/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  fabric_policies:
    ptp: 
      admin_state: false
```
