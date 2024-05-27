# SR MPLS L3out

The following table maps the subnet flags of external endpoint groups to the corresponding GUI terminology:

|Subnet Flag|GUI Terminology|
|---|---|
|`import_security`|`External Subnets for External EPG`|
|`shared_security`|`Shared Security Import Subnet`|
|`import_route_control`|`Import Route Control Subnet`|
|`export_route_control`|`Export Route Control Subnet`|
|`shared_route_control`|`Shared Route Control Subnet`|
|`aggregate_import_route_control`|`Aggregate Export`|
|`aggregate_export_route_control`|`Aggregate Import`|
|`aggregate_shared_route_control`|`Aggregate Shared Routes`|

Location in GUI:

- `Tenants` » `XXX` » `Networking` » `SR MPLS VRF L3Outs`

{{ doc_gen }}

### Examples

SR MPLS L3Out in infra tenant:

```yaml
apic:
  tenants:
    - name: infra
      sr_mpls_l3outs:
        - name: INFRA_SR_MPLS_L3
          description: Infra SR-MPLS L3out
          domain: ROUTED1
          transport_data_plane: mpls  
          node_profiles:
            - name: SR_MPLS_NP
              mpls_custom_qos_policy: MPLS_QOS
              bfd_multihop_node_policy: BFD_POL
              nodes: 
                - node_id: 101
                  router_id: 126.126.126.126
                  bgp_evpn_loopback: 127.31.2.26
                  mpls_transport_loopback: 172.31.2.26
                  segment_id: 206
              evpn_connectivity:
                - ip: 172.31.2.54
                  remote_as: 64001
                  ttl: 10
                  local_as: 31200
                  allow_self_as: true
                  disable_peer_as_check: true 
                  password: C1sco123
                  as_propagate: dual-as
                  peer_prefix_policy: BGP_PP1
              interface_profiles:
                - name: int_prof 
                  bfd_policy: BFD_POL
                  interfaces:
                    - node_id: 101
                      port: 10
                      mtu: 9000
                      ip: 5.5.5.5/24
                      bgp_peers:
                        - ip: 10.10.10.1
                          remote_as: 65123
                    - node_id: 102
                      channel: PC1
                      vlan: 101
                      ip: 6.6.6.6/24
```

SR MPLS L3Out in user tenant:

```yaml
apic:
  tenants:
    - name: ABC
      sr_mpls_l3outs:
        - name: ABC_SR_MPLS_L3OUT 
          vrf: VRF1
          sr_mpls_infra_l3outs:
            - name: INFRA_SR_MPLS_L3
              outbound_route_map: export-map
              inbound_route_map: import-map
              external_endpoint_groups:
                - ext-epg
                - ext-epg2
          external_endpoint_groups:
            - name: ext-epg
              subnets:
                - name: ALL
                  prefix: 0.0.0.0/0
                  route_leaking: true
                  security: true
                  aggregate_shared_route_control: true
              contracts:
                consumers:
                  - CON1
                providers:
                  - CON1
                imported_consumers:
                  - IMPORT-CON1
```
