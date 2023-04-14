# L3out

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
          l3outs:
            - name: ANS-L3OUT
              vrf:
                name: VRF1
                schema: ABC
                template: TEMPLATE1
```
