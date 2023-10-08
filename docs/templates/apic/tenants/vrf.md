# VRF

Location in GUI:
`Tenants` » `XXX` » `Networking` » `VRFs`

### Terraform modules

* [VRF](https://registry.terraform.io/modules/netascode/vrf/aci/latest)

{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      vrfs:
        - name: VRF1
```

Full example:

```yaml
apic:
  tenants:
    - name: ABC
      vrfs:
        - name: VRF1
          alias: VRF1-ALIAS
          description: My VRF
          data_plane_learning: false
          enforcement_direction: egress
          enforcement_preference: unenforced
          transit_route_tag_policy: TRP1
          bgp:
            timer_policy: BGP-TIMER1
          dns_labels:
            - DNS1
          contracts:
            consumers:
              - CON1
            providers:
              - CON1
            imported_consumers:
              - IMPORT-CON1
          leaked_internal_prefixes:
            - prefix: 1.1.1.0/24
              public: true
              destinations:
                - tenant: ABC
                  vrf: VRF2
                  public: false
                  description: Leak to VRF2
          leaked_external_prefixes:
            - prefix: 3.3.0.0/16
              from_prefix_length: 24
              to_prefix_length: 32
              destinations:
                - tenant: ABC
                  vrf: VRF2
                  description: Leak to VRF2
          pim:
            mtu: 9000
            fast_convergence: true
            strict_rfc: true
            resource_policy_multicast_route_map: TEST_MRM1
            max_multicast_entries: 10
            reserved_multicast_entries: 10
            static_rps:
              - ip: 1.1.1.1
              - ip: 1.1.1.2
                multicast_route_map: TEST_MRM1
            fabric_rps:
              - ip: 1.1.1.3
              - ip: 1.1.1.4
                multicast_route_map: TEST_MRM1
            auto_rp_forward_updates: true
            auto_rp_filter_multicast_route_map: TEST_MRM1
            bsr_listen_updates: true
            bsr_filter_multicast_route_map: TEST_MRM1
            asm_shared_range_multicast_route_map: TEST_MRM1
            asm_sg_expiry_multicast_route_map: TEST_MRM2
            asm_sg_expiry: 200
            asm_traffic_registry_max_rate: 100
            asm_traffic_registry_source_ip: 1.1.1.1
            ssm_group_range_multicast_route_map: TEST_MRM3
            igmp_context_ssm_translate_policies:
              - group_prefix: "228.0.0.0/8"
                source_address: 3.3.3.3
              - group_prefix: "229.0.0.0/8"
                source_address: 4.4.4.4
            inter_vrf_policies:
              - tenant: DEF
                vrf: DMZ
                multicast_route_map: TEST_MRM4
              - tenant: DEF
                vrf: DEV
```
