# BFD Switch Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Switch` » `BFD`


{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    switch_policies:
      bfd_policies:
        bfd_ipv4_policies:
          - name: BFD-IPV4-POLICY
            description: BFD IPv4 Policy
            detection_multiplier: 5
            min_transmit_interval: 100
            min_receive_interval: 50
            slow_timer_interval: 3000
            startup_timer_interval: 10
            echo_receive_interval: 50
        bfd_ipv6_policies:
          - name: BFD-IPV6-POLICY
            description: BFD IPv6 Policy
            detection_multiplier: 5
            min_transmit_interval: 100
            min_receive_interval: 50
            slow_timer_interval: 3000
            startup_timer_interval: 10
            echo_receive_interval: 50
```
