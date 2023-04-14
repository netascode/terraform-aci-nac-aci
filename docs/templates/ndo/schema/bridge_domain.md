# Bridge Domain

Location in GUI:
`Application Management` » `Schemas`

{{ aac_doc }}

### Examples

```yaml
ndo:
  schemas:
    - name: ABC
      templates:
        - name: TEMPLATE1
          bridge_domains:
            - name: BD1
              l2_unknown_unicast: proxy
              intersite_bum_traffic: false
              optimize_wan_bandwidth: false
              l2_stretch: true
              l3_multicast: false
              dhcp_relay_policy: REL1
              dhcp_option_policy: OPT1
              vrf:
                name: VRF1
                schema: ABC
                template: TEMPLATE1
              subnets:
                - ip: 1.1.1.1/24
                  scope: private
                  shared: false
                  querier: false
              sites:
                - name: APIC1
                  advertise_host_routes: true
                  l3outs:
                    - L3OUT
```
