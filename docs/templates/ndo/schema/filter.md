# Filter

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
                  stateful: true
```
