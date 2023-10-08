# OSPF Interface Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `OSPF` » `OSPF Interface`

### Terraform modules

* [OSPF Interface Policy](https://registry.terraform.io/modules/netascode/ospf-interface-policy/aci/latest)

{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        ospf_interface_policies:
          - name: OIP1
            cost: 40
```

Full example:

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        ospf_interface_policies:
          - name: OIP1
            description: My Desc
            cost: 40
            passive_interface: true
            mtu_ignore: true
            advertise_subnet: true
            bfd: true
            hello_interval: 30
            dead_interval: 180
            network_type: p2p
            priority: 2
            lsa_retransmit_interval: 6
            lsa_transmit_delay: 2
```
