# DHCP Relay Policy

Location in GUI:
`Application Management` » `Policies`

{{ aac_doc }}

### Examples

```yaml
ndo:
  policies:
    dhcp_relays:
      - name: REL1
        description: Description
        tenant: MSO1
        providers:
          - ip: 1.2.3.4
            tenant: MSO1
            schema: ABC
            template: TEMPLATE1
            application_profile: AP1
            endpoint_group: EPG1
          - ip: 1.2.3.5
            tenant: MSO1
            schema: ABC
            template: TEMPLATE1
            external_endpoint_group: EXT-EPG1
```
