# BGP Route Summarization Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BGP` » `BGP Route Summarization Policy`

### Terraform modules

* [BGP Route Summarization Policy](https://registry.terraform.io/modules/netascode/bgp-route-summarization-policy/aci/latest)

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
