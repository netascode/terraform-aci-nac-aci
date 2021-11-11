# SNMP Trap

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  fabric_policies:
    monitoring:
      snmp_traps:
        - name: trap1
          description: desc1
          destinations:
            - hostname_ip: 2.2.2.2
              port: 1062
              version: v3
              community: test
              security: priv
              mgmt_epg: inb
```
