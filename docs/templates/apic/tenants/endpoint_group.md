# Endpoint Group

Location in GUI:
`Tenants` » `XXX` » `Application Profiles` » `XXX` » `Application EPGs`


{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      application_profiles:
        - name: AP1
          endpoint_groups:
            - name: EPG1
              bridge_domain: BD1
              physical_domains:
                - PHY1
              static_ports:
                - node_id: 101
                  port: 10
                  vlan: 135
              contracts:
                consumers:
                  - CON1
```

Full example:

```yaml
apic:
  tenants:
    - name: ABC
      application_profiles:
        - name: AP1
          endpoint_groups:
            - name: EPG1
              bridge_domain: BD1
              flood_in_encap: false
              intra_epg_isolation: false
              preferred_group: false
              physical_domains:
                - PHY1
              vmware_vmm_domains:
                - name: VMM1
                  u_segmentation: true
                  delimiter: '|'
                  vlan:
                  primary_vlan: 100
                  secondary_vlan: 101
                  netflow: false
                  deployment_immediacy: lazy
                  resolution_immediacy: immediate
                  allow_promiscuous: reject
                  forged_transmits: reject
                  mac_changes: reject
                  elag: ELAGCustom
                  active_uplinks_order: 1,2
                  standby_uplinks: 3,4
              static_ports:
                - node_id: 101
                  port: 10
                  vlan: 135
                  mode: regular
                  deployment_immediacy: lazy
              static_leafs:
                - pod_id: 1
                  node_id: 101
                  vlan: 135
                  mode: regular
                  deployment_immediacy: lazy
              static_endpoints:
                - name: ST_EP1
                  mac: 00:00:00:00:00:01
                  ip: 1.1.1.1
                  type: silent-host
                  vlan: 123
                  node_id: 101
                  port: 1
              contracts:
                consumers:
                  - CON1
                providers:
                  - CON1
                imported_consumers:
                  - IMPORT-CON1
                intra_epgs:
                  - CON1
              subnets:
                - ip: 5.50.5.1/30
                  description: My Desc
                  public: true
                  private: false
                  shared: true
                  igmp_querier: true
                  nd_ra_prefix: true
                  no_default_gateway: false
                - ip: 5.50.5.5/32
                  no_default_gateway: true
                  next_hop_ip: 8.8.8.8
                  ips_pools:
                    - name: POOL1
                      start_ip: 172.16.0.1
                      end_ip: 172.16.0.10
                      dns_server: dns.cisco.com
                      dns_search_suffix: cisco
                      dns_suffix: cisco
                      wins_server: wins
                - ip: fd00:0:abcd:2::2/64
                  description: My IPv6 Desc
                  public: true
                  private: false
                  shared: false
                  igmp_querier: true
                  nd_ra_prefix: true
                  no_default_gateway: true
                  nd_ra_prefix_policy: ND-RA-PREFIX1
              tags:
                - tag1
                - tag2
              l4l7_virtual_ips:
                - ip: 11.11.11.11
                  description: My LB VIP
              l4l7_address_pools:
                - name: L4L7_POOL1
                  gateway_address: 11.11.11.254/24
                  from: 11.11.11.100
                  to: 11.11.11.200
```
