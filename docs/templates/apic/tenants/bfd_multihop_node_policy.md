# BFD Multihop Node Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BFD Multihop` » `Node Policies`


{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        bfd_multihop_node_policies:
          - name: BFD_MHOP_POL
            description: BFD multihop node policy
            detection_multiplier: 5
            min_rx_interval: 300
            min_tx_interval: 300
```
