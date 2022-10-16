# Access SPAN Filter Groups

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Troubleshooting` » `SPAN` » `SPAN Filter Groups`

{{ aac_doc }}

### Examples

```yaml
apic:
  access_policies:
    span:
      filter_groups:
        - name: FILTER-GROUP-1
          description: My SPAN Filter Group 1
          entries:
            - name: ENTRY-1
              destination_ip: 10.10.10.10
              destination_from_port: 1
              destination_to_port: 65535
              source_ip: 20.20.20.20
              source_from_port: 80
              source_to_port: 81
              ip_protocol: tcp
```
