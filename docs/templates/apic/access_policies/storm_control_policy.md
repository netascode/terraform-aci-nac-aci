# Storm Control Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Storm Control`


{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      storm_control_policies:
        - name: 20P
          alias: 20P
          burst_pps: unspecified
          rate_pps: unspecified
          burst_rate: 20
          rate: 20
```

```yaml
apic:
  access_policies:
    interface_policies:
      storm_control_policies:
        - name: 10P
          alias: 10P
          broadcast_burst_pps: unspecified
          broadcast_pps: unspecified
          broadcast_burst_rate: 10
          broadcast_rate: 10
          multicast_burst_pps: unspecified
          multicast_pps: unspecified
          multicast_burst_rate: 10
          multicast_rate: 10
          unknown_unicast_burst_pps: unspecified
          unknown_unicast_pps: unspecified
          unknown_unicast_burst_rate: 10
          unknown_unicast_rate: 10
          action: drop
```
