# DHCP Option Policy

Location in GUI:
`Application Management` » `Policies`

{{ aac_doc }}

### Examples

```yaml
ndo:
  policies:
    dhcp_options:
      - name: OPT1
        description: Description
        tenant: MSO1
        options:
          - name: OPT1
            id: 1
            data: DATA1
```
