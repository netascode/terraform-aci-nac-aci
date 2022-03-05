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
            dhcp_v6_server: true
            ipv6_router: true
            nd: true
            ra: true
```
