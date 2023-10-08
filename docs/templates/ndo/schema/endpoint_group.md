# Endpoint Group

Location in GUI:
`Application Management` » `Schemas`

{{ doc_gen }}

### Examples

On-premise Endpoint Group:

```yaml
ndo:
  schemas:
    - name: ABC
      templates:
        - name: TEMPLATE1
          application_profiles:
            - name: AP1
              endpoint_groups:
                - name: EPG1
                  useg: false
                  intra_epg_isolation: false
                  proxy_arp: false
                  preferred_group: false
                  bridge_domain:
                    name: BD1
                    schema: ABC
                    template: TEMPLATE1
                  subnets:
                    - ip: 2.2.2.2/24
                      scope: private
                      shared: false
                      no_default_gateway: true
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
                          u_segmentation: true
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
                          shared: false
                          no_default_gateway: false
```

Azure Endpoint Group:

```yaml
ndo:
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
```
