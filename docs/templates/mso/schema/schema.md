# Schema

Description

{{ aac_doc }}
### Examples

### On-premise Schema

```yaml
mso:
  schemas:
    - name: ABC
      templates:
        - name: TEMPLATE1
          tenant: MSO1
          application_profiles:
            - name: AP1
              endpoint_groups:
                - name: EPG1
                  useg: disabled
                  intra_epg_isolation: disabled
                  proxy_arp: disabled
                  preferred_group: disabled
                  bridge_domain:
                    name: BD1
                    schema: ABC
                    template: TEMPLATE1
                  subnets:
                    - ip: 2.2.2.2/24
                      scope: private
                      shared: disabled
                      no_default_gateway: enabled
                  contracts:
                    consumers:
                      - name: CONTRACT1
                        schema: ABC
                        template: TEMPLATE1
                    providers:
                      - name: CONTRACT1
                        schema: ABC
                        template: TEMPLATE1
                  sites:
                    - name: APIC1
                      physical_domains:
                        - name: ANS-PHY
                          deployment_immediacy: immediate
                          resolution_immediacy: immediate
                      vmware_vmm_domains:
                        - name: ANS-VMM1
                          deployment_immediacy: lazy
                          resolution_immediacy: immediate
                          vlan_mode: static
                          vlan: 123
                          u_segmentation: enabled
                          useg_vlan: 124
                      static_ports:
                        - type: port
                          pod: 1
                          node: 101
                          port: 40
                          vlan: 234
                          deployment_immediacy: lazy
                          mode: regular
                      static_leafs:
                        - pod: 1
                          node: 102
                          vlan: 234
                      subnets:
                        - ip: 6.5.4.3/24
                          description: Description
                          scope: private
                          shared: disabled
                          no_default_gateway: disabled
          vrfs:
            - name: VRF1
              l3_multicast: enabled
              preferred_group: disabled
          bridge_domains:
            - name: BD1
              l2_unknown_unicast: proxy
              intersite_bum_traffic: disabled
              optimize_wan_bandwidth: disabled
              l2_stretch: enabled
              l3_multicast: disabled
              dhcp_relay_policy: REL1
              dhcp_option_policy: OPT1
              vrf:
                name: VRF1
                schema: ABC
                template: TEMPLATE1
              subnets:
                - ip: 1.1.1.1/24
                  scope: private
                  shared: disabled
                  querier: disabled
              sites:
                - name: APIC1
                  advertise_host_routes: enabled
                  l3outs:
                    - L3OUT
          filters:
            - name: FILTER1
              entries:
                - name: HTTP
                  description: HTTP Filter
                  ethertype: ip
                  protocol: tcp
                  source_from_port: unspecified
                  source_to_port: unspecified
                  destination_from_port: 80
                  destination_to_port: 80
                  stateful: enabled
          l3outs:
            - name: ANS-L3OUT
              vrf:
                name: VRF1
                schema: ABC
                template: TEMPLATE1
          external_endpoint_groups:
            - name: EXT-EPG1
              preferred_group: disabled
              vrf:
                name: VRF1
                schema: ABC
                template: TEMPLATE1
              subnets:
                - prefix: 0.0.0.0/0
                  import_route_control: 'yes'
                  export_route_control: 'yes'
                  shared_route_control: 'yes'
                  import_security: 'yes'
                  shared_security: 'yes'
                  aggregate_import: 'yes'
                  aggregate_export: 'yes'
                  aggregate_shared: 'yes'
                - prefix: 10.0.0.0/8
              contracts:
                consumers:
                  - name: CONTRACT1
                    schema: ABC
                    template: TEMPLATE1
                providers:
                  - name: CONTRACT1
                    schema: ABC
                    template: TEMPLATE1
              sites:
                - name: APIC1
                  tenant: MSO1
                  l3out: ANS-L3OUT
          contracts:
            - name: CONTRACT1
              scope: context
              type: bothWay
              filters:
                - name: FILTER1
                  schema: ABC
                  template: TEMPLATE1
                  log: enabled
              service_graph:
                name: SG1
                nodes:
                  - name: FW1
                    provider:
                      bridge_domain: BD1
                      sites:
                        - name: APIC1
                          device: DEV1
                          logical_interface: INT1
                          redirect_policy: PBR1
                    consumer:
                      bridge_domain: BD1
                      sites:
                        - name: APIC1
                          device: DEV1
                          logical_interface: INT1
                          redirect_policy: PBR1
          service_graphs:
            - name: SG1
              description: Description
              nodes:
                - name: FW1
                  sites:
                    - name: APIC1
                      device: DEV1
          sites:
            - APIC1
```

### Azure Schema

```yaml
mso:
  schemas:
    - name: AZURE1
      templates:
        - name: TEMPLATE1
          tenant: AZURE1
          application_profiles:
            - name: AP1
              endpoint_groups:
                - name: EPG1
                  vrf:
                    name: VRF1
                  sites:
                    - name: AZURE-SITE1
                      selectors:
                        - name: SELECTOR1
                          expressions:
                            - key: ipAddress
                              operator: equals
                              value: 5.5.5.5
          vrfs:
            - name: VRF1
              sites:
                - name: AZURE-SITE1
                  regions:
                    - name: eastus
                      hub_network: enabled
                      hub_network_name: default
                      hub_network_tenant: infra
                      cidrs:
                        - ip: 172.31.0.0/24
          external_endpoint_groups:
            - name: EXT-EPG1
              type: cloud
              vrf:
                name: VRF1
              application_profile:
                name: AP1
              selectors:
                - name: SELECTOR1
                  ips:
                    - 10.1.1.1
                    - 10.1.1.2
              sites:
                - name: AZURE-SITE1
                  selectors:
                    - name: SELECTOR2
                      ips:
                        - 10.1.1.3
                        - 10.1.1.4
          sites:
            - AZURE-SITE1
```
