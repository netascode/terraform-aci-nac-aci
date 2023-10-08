# BGP Timer Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BGP` » `BGP Timers`

### Terraform modules

* [BGP Timer Policy](https://registry.terraform.io/modules/netascode/bgp-timer-policy/aci/latest)

{{ doc_gen }}

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
            graceful_restart_helper: false
            maximum_as_limit: 2
```
