# Rogue EP Control

Location in GUI:
`System` » `System Settings` » `Endpoint Controls` » `Rogue EP Control`


{{ doc_gen }}

### Examples

```yaml
apic:
  fabric_policies:
    rogue_ep_control:
      admin_state: false
      detection_interval: 180
      detection_multiplier: 10
      hold_interval: 1900
```
