# VRF

Location in GUI:
`Application Management` » `Schemas`

{{ doc_gen }}

### Examples

On-premise VRF:

```yaml
ndo:
  schemas:
    - name: ABC
      templates:
        - name: TEMPLATE1
          vrfs:
            - name: VRF1
              data_plane_learning: true
              preferred_group: false
              l3_multicast: true
              vzany: true
              contracts:
                consumers:
                  - name: CONTRACT2
```

Azure VRF:

```yaml
ndo:
  schemas:
    - name: AZURE1
      templates:
        - name: TEMPLATE1
          vrfs:
            - name: VRF1
              sites:
                - name: AZURE-SITE1
                  regions:
                    - name: eastus
                      hub_network: true
                      hub_network_name: default
                      hub_network_tenant: infra
                      cidrs:
                        - ip: 172.31.0.0/24
```
