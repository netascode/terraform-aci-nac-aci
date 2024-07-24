# EP Loop Protection

Location in GUI:
`System` » `System Settings` » `Endpoint Controls`


{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    ep_loop_protection:
      admin_state: true
      detection_interval: 180
      detection_multiplier: 10
      port_disable: true
      bd_learn_disable: false
```
