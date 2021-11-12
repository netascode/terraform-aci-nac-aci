# Syslog

Location in GUI:
`Admin` » `External Data Collectors` » `Monitoring Destinations` » `Syslog`

### Terraform modules

* [Syslog](https://registry.terraform.io/modules/netascode/syslog/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  fabric_policies:
    monitoring:
      syslogs:
        - name: syslog1
          description: desc1
          admin_state: disabled
          format: nxos
          show_millisecond: enabled
          local_admin_state: disabled
          local_severity: emergencies
          console_admin_state: disabled
          console_severity: alerts
          destinations:
            - hostname_ip: 2.2.2.2
              port: 1234
              admin_state: disabled
              facility: local0
              severity: emergencies
              mgmt_epg: inb
            - hostname_ip: 2.2.2.3
```
