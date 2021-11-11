# L3out

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      l3outs:
        - name: L3OUT1
          alias: L3OUT1-ALIAS
          description: My Desc
          target_dscp: AF13
          qos_class: level3
          custom_qos_policy: QOS_POLICY
          vrf: VRF1
          domain: ROUTED1
          bfd_policy: BFD1
          ospf:
            area: 0
            area_type: regular
            area_cost: 1
            auth_type: simple
            auth_key: cisco
            auth_key_id: 1
            policy: OIP1
          interleak_route_map: ROUTE_MAP1
          default_route_leak_policy:
            always: 'no'
            criteria: 'in-addition'
            context_scope: 'no'
            outside_scope: 'no'
          redistribution_route_maps:
            - source: direct
              route_map: ROUTE_MAP2
          dampening_ipv4_route_map: ROUTE_MAP3
          dampening_ipv6_route_map: ROUTE_MAP4
          nodes:
            - node_id: 101
              router_id: 5.5.5.5
              router_id_as_loopback: 'yes'
              static_routes:
                - prefix: 2.2.2.0/24
                  description: My Desc
                  preference: 1
                  next_hops:
                    - ip: 6.6.6.6
              interfaces:
                - channel: VPC1
                  svi: 'yes'
                  vlan: 301
                  ip_a: 14.14.14.1/24
                  ip_b: 14.14.14.2/24
                  ip_shared: 14.14.14.3/24
                  bgp_peers:
                    - ip: 14.14.14.14
                      remote_as: 65010
                      description: My Desc
                      bfd: enabled
                      allow_self_as: 'yes'
                      as_override: 'yes'
                      bfd: 'yes'
                      disable_connected_check: 'yes'
                      remove_private_as: 'yes'
                      remove_all_private_as: 'yes'
                      multicast_address_family: 'yes'
                      ttl: 1
                      weight: 0
                      password: C1sco123
                      local_as: 1234
                      as_propagate: dual-as
                      peer_prefix_policy: BGP_PP1
                      export_route_control: ROUTE_MAP1
                      import_route_control: ROUTE_MAP2
          import_route_map:
            description: desc
            type: global
            contexts:
              - name: CONTEXT1
                description: desc1
                action: deny
                order: 2
                match_rule: MATCH1
                set_rule: SET1
          export_route_map:
            contexts:
              - name: CONTEXT1
                match_rule: MATCH2
                set_rule: SET2
```
