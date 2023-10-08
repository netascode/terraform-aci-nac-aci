# Contract

Location in GUI:
`Application Management` » `Schemas`

{{ doc_gen }}

### Examples

```yaml
ndo:
  schemas:
    - name: ABC
      templates:
        - name: TEMPLATE1
          contracts:
            - name: CONTRACT1
              scope: context
              type: bothWay
              filters:
                - name: FILTER1
                  schema: ABC
                  template: TEMPLATE1
                  log: true
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
```
