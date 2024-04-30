# SNMP Trap

Location in GUI:
`Admin` » `External Data Collectors` » `Monitoring Destinations` » `SNMP`


{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  fabric_policies:
    monitoring:
      snmp_traps:
        - name: TRAP1
          destinations:
            - hostname_ip: 2.2.2.2
              community: testcommunity
```

Full example:

```yaml
apic:
  fabric_policies:
    monitoring:
      snmp_traps:
        - name: TRAP1
          description: desc1
          destinations:
            - hostname_ip: 2.2.2.2
              port: 1062
              version: v3
              community: test
              security: priv
              mgmt_epg: inb
```
