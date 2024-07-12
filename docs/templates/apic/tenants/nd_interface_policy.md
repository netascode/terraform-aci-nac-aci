# ND Interface Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `ND Interface`

{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        nd_interface_policies:
          - name: ND-INTF-POL1
            controller_state: 
              - managed-cfg
            hop_limit: 8
            ns_tx_interval: 1000
            mtu: 9000
            retransmit_retry_count: 3
```
