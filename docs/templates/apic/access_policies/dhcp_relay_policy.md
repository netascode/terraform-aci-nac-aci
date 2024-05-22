# Infra DHCP Relay Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Global` » `DHCP` » `Relay Policies`

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    dhcp_relay_policies:
      - name: INFRA-DHCP-RELAY1
        description: "My Description"
        providers:
          - ip: 6.6.6.6
            type: epg
            tenant: ABC
            application_profile: AP1
            endpoint_group: EPG1
```
