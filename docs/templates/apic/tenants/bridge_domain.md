# Bridge Domain

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      bridge_domains:
        - name: BD1
          alias: ABC_BD1
          mac: 00:22:BD:F8:19:FE
          arp_flooding: 'no'
          ip_dataplane_learning: 'no'
          limit_ip_learn_to_subnets: 'no'
          multi_destination_flooding: encap-flood
          unknown_unicast: proxy
          unknown_ipv4_multicast: flood
          unknown_ipv6_multicast: flood
          unicast_routing: 'yes'
          advertise_host_routes: 'yes'
          l3_multicast: 'no'
          vrf: VRF1
          subnets:
            - ip: 1.1.1.1/24
              description: My Desc
              primary_ip: 'yes'
              public: 'yes'
              private: 'no'
              shared: 'yes'
              virtual: 'no'
              igmp_querier: 'yes'
              nd_ra_prefix: 'yes'
              no_default_gateway: 'no'
          l3outs:
            - L3OUT1
          dhcp_labels:
            - dhcp_relay_policy: DHCP-RELAY1
              dhcp_option_policy: DHCP-OPTION1
```
