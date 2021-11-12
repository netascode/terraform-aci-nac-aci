# Site Fabric Connectivity

Location in GUI:
`Infrastructure` » `Infra Configuration`

{{ aac_doc }}
### Examples

```yaml
mso:
  sites:
    - name: APIC1
      multisite: enabled
      multicast_tep: 5.6.7.8
      bgp:
        as: 65009
        password: cisco
      ospf:
        area_id: 0
        area_type: regular
      routed_domain: L3
      ospf_policies:
        - name: IPN
          network_type: point-to-point
          priority: 1
          interface_cost: 0
          passive_interface: disabled
          mtu_ignore: disabled
          advertise_subnet: disabled
          bfd: disabled
          hello_interval: 10
          dead_interval: 40
          retransmit_interval: 5
          retransmit_delay: 1
      pods:
        - id: 1
          unicast_tep: 3.4.5.6
          spines:
            - id: 1001
              name: SPINE1001
              bgp_peering: enabled
              bgp_route_reflector: disabled
              control_plane_tep: 100.100.100.1
              interfaces:
                - port: 1
                  ip: 11.11.11.1/24
                  mtu: inherit
                  ospf:
                    policy: IPN
                    authentication_type: none
                    authentication_key: cisco
                    authentication_key_id: 1
  fabric_connectivity:
    bgp:
      peering_type: full-mesh
      ttl: 15
      max_as: 10
      keepalive_interval: 30
      hold_interval: 90
      stale_interval: 180
      graceful_restart: disabled
```
