# Redirect Policy

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      services:
        redirect_policies:
          - name: PBR1
            alias: PBR1
            description: My Desc
            type: L3
            anycast: disabled
            hashing: sip-dip-prototype
            threshold: disabled
            max_threshold: 0
            min_threshold: 0
            threshold_down_action: permit
            resilient_hashing: disabled
            redirect_backup_policy: L4L7_REDIRECT_BACKUP1
            l3_destinations:
              - description: My Desc
                ip: 1.1.1.1
                ip_2:
                mac: 00:00:00:11:22:33
                pod: 1
                redirect_health_group: HEALTH_GROUP_1
```
