# Scheduler

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  fabric_policies:
    schedulers:
      - name: scheduler1
        description: desc1
        recurring_windows:
          - name: window1
            day: Monday
            hour: 23
            minute: 1
```
