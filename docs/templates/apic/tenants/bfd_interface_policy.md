# BFD Interface Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BFD`

### Terraform modules

* [BFD Interface Policy](https://registry.terraform.io/modules/netascode/bfd-interface-policy/aci/latest)

{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        bfd_interface_policies:
          - name: BFD1
            subinterface_optimization: true
```

Full example:

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        bfd_interface_policies:
          - name: BFD1
            description: descr
            subinterface_optimization: true
            detection_multiplier: 5
            echo_admin_state: false
            echo_rx_interval: 100
            min_rx_interval: 100
            min_tx_interval: 100
```
