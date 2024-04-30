# DHCP Relay Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `DHCP` » `Relay Policies`


{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        dhcp_relay_policies:
          - name: DHCP-RELAY1
            description: "My Description"
            providers:
              - ip: 6.6.6.6
                type: epg
                tenant: ABC
                application_profile: AP1
                endpoint_group: EPG1
```
