# Error Disabled Recovery Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Global` » `Error Disabled Recovery Policy`

### Terraform modules

* [Error Disabled Recovery](https://registry.terraform.io/modules/netascode/error-disabled-recovery/aci/latest)

{{ aac_doc }}

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
