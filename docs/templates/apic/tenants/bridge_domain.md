# Bridge Domain

Location in GUI:
`Tenants` » `XXX` » `Networking` » `Bridge Domains`


{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      bridge_domains:
        - name: BD1
          vrf: VRF1
          subnets:
            - ip: 1.1.1.1/24
```

Full example:

```yaml
apic:
  tenants:
    - name: ABC
      bridge_domains:
        - name: BD1
          alias: ABC_BD1
          mac: 00:22:BD:F8:19:FE
          virtual_mac: 00:23:BD:F8:19:12
          ep_move_detection: true
          arp_flooding: false
          ip_dataplane_learning: false
          limit_ip_learn_to_subnets: false
          multi_destination_flooding: encap-flood
          unknown_unicast: proxy
          unknown_ipv4_multicast: flood
          unknown_ipv6_multicast: flood
          unicast_routing: true
          clear_remote_mac_entries: true
          advertise_host_routes: true
          l3_multicast: false
          vrf: VRF1
          subnets:
            - ip: 1.1.1.1/24
              description: My Desc
              primary_ip: true
              public: true
              private: false
              shared: true
              virtual: false
              igmp_querier: true
              nd_ra_prefix: true
              no_default_gateway: false
            - ip: fd00:0:abcd:1::1/64
              description: My IPv6 Desc
              primary_ip: true
              public: true
              private: false
              shared: false
              virtual: false
              igmp_querier: true
              nd_ra_prefix: true
              no_default_gateway: false
              nd_ra_prefix_policy: ND-RA-PREFIX1
          l3outs:
            - L3OUT1
          dhcp_labels:
            - dhcp_relay_policy: DHCP-RELAY1
              dhcp_option_policy: DHCP-OPTION1
```
