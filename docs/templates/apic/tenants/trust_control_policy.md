# Trust Control Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `First Hop Security` » `Trust Control Policies`

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        trust_control_policies:
          - name: TRUST_ALL
            description: My Trust Policy
            dhcp_v6_server: 'yes'
            ipv6_router: 'yes'
            nd: 'yes'
            ra: 'yes'
```
