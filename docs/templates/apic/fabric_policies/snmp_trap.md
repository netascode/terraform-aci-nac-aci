# SNMP Trap

Location in GUI:
`Admin` » `External Data Collectors` » `Monitoring Destinations` » `SNMP`

### Terraform modules

* [SNMP Trap Policy](https://registry.terraform.io/modules/netascode/snmp-trap-policy/aci/latest)

{{ aac_doc }}
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
