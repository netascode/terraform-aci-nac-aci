# DHCP Option Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `DHCP` » `Option Policies`


{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        dhcp_option_policies:
          - name: DHCP-OPTION1
            description: "My Description"
            options:
              - name: OPTION1
                id: 13
                data: DATA1
```
