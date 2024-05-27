# L3out

L3out Node and Interface Profiles can either be auto-generated, one per L3out, or can be defined explicitly.

> Note: Whether an interface is an `svi`, `routed sub-interface`, or `routed` depends on the following configuration:

**svi** - `vlan: <not null>`, `svi: true`, `ip: <not null>`

**routed sub-interface** - `vlan: <not null>`, `svi: false`, `ip: <not null>`

**routed interface** - `vlan: <null>`, `svi: false`, `ip: <not null>`

Location in GUI:

- `Tenants` » `XXX` » `Networking` » `L3outs`

{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      l3outs:
        - name: L3OUT1
          vrf: VRF1
          domain: ROUTED1
          nodes:
            - node_id: 101
              router_id: 5.5.5.5
              static_routes:
                - prefix: 2.2.2.0/24
                  description: My Desc
                  next_hops:
                    - ip: 6.6.6.6
                  track_list: TRACK_POL
              interfaces:
                - node_id: 101
                  port: 10
                  vlan: 301
                  ip: 14.14.14.1/24
                  bgp_peers:
                    - ip: 14.14.14.14
                      remote_as: 65010
```

SVI example:

```yaml
apic:
  tenants:
    - name: ABC
      l3outs:
        - name: L3OUT1
          vrf: VRF1
          domain: ROUTED1
          node_profiles:
            - name: NODE_101
              nodes:
                - node_id: 101
                  router_id: 5.5.5.5
                  static_routes:
                    - prefix: 2.2.2.0/24
                      description: My Desc
                      next_hops:
                        - ip: 6.6.6.6
              interface_profiles:
                - name: NODE_101
                  interfaces:
                    - node_id: 101
                      port: 10
                      vlan: 301
                      svi: true
                      ip: 14.14.14.1/24
```

Routed Sub-interface example:

```yaml
apic:
  tenants:
    - name: ABC
      l3outs:
        - name: L3OUT1
          vrf: VRF1
          domain: ROUTED1
          node_profiles:
            - name: NODE_101
              nodes:
                - node_id: 101
                  router_id: 5.5.5.5
                  static_routes:
                    - prefix: 2.2.2.0/24
                      description: My Desc
                      next_hops:
                        - ip: 6.6.6.6
              interface_profiles:
                - name: NODE_101
                  interfaces:
                    - node_id: 101
                      port: 10
                      vlan: 301
                      svi: false
                      ip: 14.14.14.1/24
```

Routed Interface example:

```yaml
apic:
  tenants:
    - name: ABC
      l3outs:
        - name: L3OUT1
          vrf: VRF1
          domain: ROUTED1
          node_profiles:
            - name: NODE_101
              nodes:
                - node_id: 101
                  router_id: 5.5.5.5
                  static_routes:
                    - prefix: 2.2.2.0/24
                      description: My Desc
                      next_hops:
                        - ip: 6.6.6.6
              interface_profiles:
                - name: NODE_101
                  interfaces:
                    - node_id: 101
                      port: 10
                      ip: 14.14.14.1/24
```

Example with explicit profiles:

```yaml
apic:
  tenants:
    - name: ABC
      l3outs:
        - name: L3OUT1
          vrf: VRF1
          domain: ROUTED1
          node_profiles:
            - name: NODE_101
              nodes:
                - node_id: 101
                  router_id: 5.5.5.5
                  static_routes:
                    - prefix: 2.2.2.0/24
                      description: My Desc
                      next_hops:
                        - ip: 6.6.6.6
              interface_profiles:
                - name: NODE_101
                  interfaces:
                    - node_id: 101
                      port: 10
                      vlan: 301
                      ip: 14.14.14.1/24
                      bgp_peers:
                        - ip: 14.14.14.14
                          remote_as: 65010
```

Full example:

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
          import_route_control_enforcement: true
          export_route_control_enforcement: true
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
            always: false
            criteria: 'in-addition'
            context_scope: false
            outside_scope: false
          redistribution_route_maps:
            - source: direct
              route_map: ROUTE_MAP2
          dampening_ipv4_route_map: ROUTE_MAP3
          dampening_ipv6_route_map: ROUTE_MAP4
          nodes:
            - node_id: 101
              router_id: 5.5.5.5
              router_id_as_loopback: true
              static_routes:
                - prefix: 2.2.2.0/24
                  description: My Desc
                  preference: 1
                  next_hops:
                    - ip: 6.6.6.6
              interfaces:
                - channel: VPC1
                  svi: true
                  scope: local
                  vlan: 301
                  ip_a: 14.14.14.1/24
                  ip_b: 14.14.14.2/24
                  ip_shared: 14.14.14.3/24
                  mode: native
                  bgp_peers:
                    - ip: 14.14.14.14
                      remote_as: 65010
                      description: My Desc
                      allow_self_as: true
                      as_override: true
                      bfd: true
                      disable_connected_check: true
                      remove_private_as: true
                      remove_all_private_as: true
                      multicast_address_family: true
                      ttl: 1
                      weight: 0
                      password: C1sco123
                      local_as: 1234
                      as_propagate: dual-as
                      peer_prefix_policy: BGP_PP1
                      export_route_control: ROUTE_MAP1
                      import_route_control: ROUTE_MAP2
          import_route_map:
            name: example-import-name
            description: desc
            type: global
            contexts:
              - name: CONTEXT1
                description: desc1
                action: deny
                order: 2
                match_rules:
                - MATCH1
                set_rule: SET1
          export_route_map:
          name: example-export-name
            contexts:
              - name: CONTEXT1
                match_rules:
                - MATCH2
                set_rule: SET2
```
