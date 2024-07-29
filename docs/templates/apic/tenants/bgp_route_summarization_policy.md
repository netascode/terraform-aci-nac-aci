# BGP Route Summarization Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BGP` » `BGP Route Summarization Policy`

{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        bgp_route_summarization_policies:
          - name: BGP_ROUTE_SUMMARIZATION1
            description: BGP_Route_Summarization_Policy
            as_set: true
            summary_only: false
            af_mcast: false
            af_ucast: true
```
