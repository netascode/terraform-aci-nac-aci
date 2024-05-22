# PTP Profile

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Global` » `PTP User Profile`

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    ptp_profiles:
      - name: MY_PTP_PROFILE
        template: telecom
        announce_interval: -3
        delay_interval: -4
        sync_interval: -4
```
