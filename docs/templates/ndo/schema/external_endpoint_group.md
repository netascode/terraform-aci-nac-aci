# External Endpoint Group

Location in GUI:
`Application Management` » `Schemas`

{{ aac_doc }}

### Examples

### On-premise External Endpoint Group

```yaml
ndo:
  schemas:
    - name: ABC
      templates:
        - name: TEMPLATE1
          external_endpoint_groups:
            - name: EXT-EPG1
              preferred_group: false
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
```

### Azure External Endpoint Group

```yaml
ndo:
  schemas:
    - name: AZURE1
      templates:
        - name: TEMPLATE1
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
```
