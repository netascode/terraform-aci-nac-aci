# DHCP Relay Policy

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        dhcp_relay_policies:
          - name: DHCP-RELAY1
            description: a_description
            providers:
              - ip: 6.6.6.6
                type: epg
                tenant: ABC
                application_profile: AP1
                endpoint_group: EPG1
```
