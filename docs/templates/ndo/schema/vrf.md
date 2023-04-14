# VRF

Location in GUI:
`Application Management` » `Schemas`

{{ aac_doc }}

### Examples

### On-premise VRF

```yaml
ndo:
  schemas:
    - name: ABC
      templates:
        - name: TEMPLATE1
          vrfs:
            - name: VRF1
              l3_multicast: true
              preferred_group: false
```

### Azure VRF

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
