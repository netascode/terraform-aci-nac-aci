# DHCP Option Policy

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        dhcp_option_policies:
          - name: DHCP-OPTION1
            description: a_description
            options:
              - name: OPTION1
                id: 13
                data: DATA1
```
