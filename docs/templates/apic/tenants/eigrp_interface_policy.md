# EIGRP Interface Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `EIGRP` » `EIGRP Interface`


{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        eigrp_interface_policies:
          - name: EIP1

```

Full example:

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        eigrp_interface_policies:
          - name: EIP1
            description: My Desc
            bfd: false
            self_nexthop: true
            passive_interface: false
            split_horizon: true
            hello_interval: 5
            hold_interval: 15
            bandwidth: 0
            delay: 0
```
