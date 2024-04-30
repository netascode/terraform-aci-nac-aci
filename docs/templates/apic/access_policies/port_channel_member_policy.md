# Port Channel Member Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Port Channel Member`


{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      port_channel_member_policies:
        - name: FAST
          rate: fast
          priority: 32768
```
