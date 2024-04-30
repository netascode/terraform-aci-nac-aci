# System Performance

Location in GUI:
`System` » `System Settings` » `System Performance`


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
