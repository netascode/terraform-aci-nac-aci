# vPC Switch Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Switch` » `VPC Domain`


{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    switch_policies:
      vpc_policies:
        - name: VPC300
          peer_dead_interval: 300
          delay_restore_timer: 210
```
