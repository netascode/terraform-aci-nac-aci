# BGP Policy

Location in GUI:
`System` » `System Settings` » `BGP Route Reflector`


{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    fabric_bgp_as: 65009
    fabric_bgp_rr:
      - 1001
    fabric_bgp_ext_rr:
      - 1001
```
