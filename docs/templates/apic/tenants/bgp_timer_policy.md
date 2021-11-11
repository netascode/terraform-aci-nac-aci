# BGP Timer Policy

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        bgp_timer_policies:
          - name: BGP-TIMER1
            description: BGP_POLICY
            keepalive_interval: 30
            hold_interval: 300
            stale_interval: 200
            graceful_restart_helper: disabled
            maximum_as_limit: 2
```
