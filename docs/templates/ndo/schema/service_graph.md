# Service Graph

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
          service_graphs:
            - name: SG1
              description: Description
              nodes:
                - name: FW1
                  sites:
                    - name: APIC1
                      device: DEV1
```
