# Track List

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `IP SLA` » `Track Lists`

{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        track_lists:
          - name: TRACK_LIST
            type: percentage
            percentage_up: 10
            percentage_down: 2
            track_members:
              - TRACK_MEM1
              - TRACK_MEM2
```
