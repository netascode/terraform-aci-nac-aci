# DHCP Relay Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `DHCP` » `Relay Policies`

### Terraform modules

* [DHCP Relay Policy](https://registry.terraform.io/modules/netascode/dhcp-relay-policy/aci/latest)

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
