# Error Disabled Recovery Policy

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  fabric_policies:
    err_disabled_recovery:
      interval: 360
      mcp_loop: 'yes'
      ep_move: 'yes'
      bpdu_guard: 'yes'
```
