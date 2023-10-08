# Redirect Backup Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `L4-L7 Policy-Based Redirect Backup`

{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      services:
        redirect_backup_policies:
          - name: L4L7_REDIRECT_BACKUP_1
            l3_destinations:
              - ip: 5.6.7.8
                mac: 00:00:00:11:22:33
                redirect_health_group: HEALTH_GROUP_1
```
