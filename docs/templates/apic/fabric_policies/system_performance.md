# System Performance

Location in GUI:
`System` » `System Settings` » `System Performance`

### Terraform modules

* [System Performance](https://registry.terraform.io/modules/netascode/system-performance/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    system_performance:
        admin_state: True
        response_threshold: 8500
        top_slowest_requests: 5
        calculation_window: 300
```
