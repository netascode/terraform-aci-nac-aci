# Error Disabled Recovery Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Global` » `Error Disabled Recovery Policy`


{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    err_disabled_recovery:
      interval: 360
      mcp_loop: true
      ep_move: true
      bpdu_guard: true
```
