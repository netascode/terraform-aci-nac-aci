# BGP Peer Prefix Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BGP` » `BGP Peer Prefix`

{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        bgp_peer_prefix_policies:
          - name: BGP_PP1
            description: "My BGP PP Policy 1"
            action: 'shut'
            threshold: 90
            max_prefixes: 10000
```
