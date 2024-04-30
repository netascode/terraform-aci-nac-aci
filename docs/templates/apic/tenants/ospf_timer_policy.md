# OSPF Timer Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `OSPF` » `OSPF Timer Policy`


{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        ospf_timer_policies:
          - name: OSPF_TIMER
            reference_bandwidth: 40001
            distance: 111
```

Full example:

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        ospf_timer_policies:
          - name: OSPF_TIMER_NON_DEFAULT_TIMER
            reference_bandwidth: 40001
            distance: 111
            graceful_restart: false
            router_id_lookup: true
            prefix_suppression: true
            max_ecmp: 9
            spf_init_interval: 201
            spf_hold_interval: 1001
            spf_max_interval: 5001
            lsa_group_pacing_interval: 11
            lsa_hold_interval: 5001
            lsa_start_interval: 1
            lsa_max_interval: 5002
            lsa_arrival_interval: 1001
            max_lsa_num: 20001
            max_lsa_threshold: 76
            max_lsa_action: log
```
