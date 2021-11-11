# EP Loop Protection

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  fabric_policies:
    ep_loop_protection:
      admin_state: enabled
      detection_interval: 180
      detection_multiplier: 10
      action: port-disable
```
