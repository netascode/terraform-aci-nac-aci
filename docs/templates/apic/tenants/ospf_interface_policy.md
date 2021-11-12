# OSPF Interface Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `OSPF` » `OSPF Interface`

### Terraform modules

* [OSPF Interface Policy](https://registry.terraform.io/modules/netascode/ospf-interface-policy/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        ospf_interface_policies:
          - name: OIP1
            description: My Desc
            cost: 40
            passive_interface: 'yes'
            mtu_ignore: 'yes'
            advertise_subnet: 'yes'
            bfd: 'yes'
            hello_interval: 30
            dead_interval: 180
            network_type: p2p
            priority: 2
            lsa_retransmit_interval: 6
            lsa_transmit_delay: 2
```
