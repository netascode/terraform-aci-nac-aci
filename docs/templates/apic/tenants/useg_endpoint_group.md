# uSeg Endpoint Group

Location in GUI:
`Tenants` » `XXX` » `Application Profiles` » `XXX` » `uSeg EPGs`


{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      application_profiles:
        - name: AP1
          useg_endpoint_groups:
            - name: uSeg_EPG1
              bridge_domain: BD1
              physical_domains:
                - PHY1
              static_leafs:
                - node_id: 102
              contracts:
                consumers:
                  - CON1
              useg_attributes:
                ip_statements:
                  - name: ip_1
                    use_epg_subnet: false
                    ip: 5.50.6.128/25
                mac_statements:
                  - name: mac_1
                    mac: 02:42:68:22:58:D1
```

Full example:

```yaml
apic:
  tenants:
    - name: ABC
      application_profiles:
        - name: AP1
          useg_endpoint_groups:
            - name: uSeg_EPG1
              bridge_domain: BD1
              flood_in_encap: false
              intra_epg_isolation: false
              preferred_group: false
              trust_control_policy: TRUST_ALL
              qos_class: level3
              custom_qos_policy: QOS_POL
              physical_domains:
                - PHY1
              vmware_vmm_domains:
                - name: VMM1
                  netflow: false
                  deployment_immediacy: lazy
                  elag: ELAGCustom
                  active_uplinks_order: 1,2
                  standby_uplinks: 3,4
              static_leafs:
                - node_id: 102
              contracts:
                consumers:
                  - CON1
                providers:
                  - CON1
                imported_consumers:
                  - IMPORT-CON1
                intra_epgs:
                  - CON1
                masters:
                  - application_profile: AP1
                    endpoint_group: EPG1
              useg_attributes:
                match_type: any
                ip_statements:
                  - name: ip_1
                    use_epg_subnet: false
                    ip: 5.50.6.128/25
                  - name: ip_2
                    use_epg_subnet: true
                mac_statements:
                  - name: mac_1
                    mac: 02:42:68:22:58:D1
                  - name: mac_2
                    mac: 02:42:68:22:58:D2
              subnets:
                - ip: 5.50.6.1/30
                  description: My Desc
                  public: true
                  private: false
                  shared: true
                  igmp_querier: true
                  nd_ra_prefix: true
                  no_default_gateway: false
                - ip: 5.50.6.5/32
                  no_default_gateway: true
                  next_hop_ip: 8.8.8.8
                  ip_pools:
                    - name: POOL1
                      start_ip: 172.16.1.1
                      end_ip: 172.16.1.10
                      dns_server: dns.cisco.com
                      dns_search_suffix: cisco
                      dns_suffix: cisco
                      wins_server: wins
                    - name: POOL2
                - ip: 5.50.6.6/32
                  no_default_gateway: true
                  anycast_mac: 00:00:00:01:02:03
                - ip: 5.50.6.7/32
                  no_default_gateway: true
                  nlb_mode: mode-mcast-igmp
                  nlb_group: 230.1.1.1
                - ip: 5.50.6.8/32
                  no_default_gateway: true
                  nlb_mode: mode-uc
                  nlb_mac: 00:00:00:01:01:01
                - ip: 5.50.6.9/32
                  no_default_gateway: true
                  nlb_mode: mode-mcast-static
                  nlb_mac: 03:00:0C:CC:CC:CC
                - ip: fd00:0:abcd:2::2/64
                  description: My IPv6 Desc
                  public: true
                  private: false
                  shared: false
                  igmp_querier: true
                  nd_ra_prefix: true
                  no_default_gateway: false
                  nd_ra_prefix_policy: ND_RA_PREFIX1
              tags:
                - tag1
                - tag2
              l4l7_address_pools:
                - name: L4L7_POOL1
                  gateway_address: 11.11.12.254/24
                  from: 11.11.12.100
                  to: 11.11.12.200
```
