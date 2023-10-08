# DHCP Option Policy

This policy is only supported up to NDO version 3.7.

Location in GUI:
`Application Management` » `Policies`

{{ doc_gen }}

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
