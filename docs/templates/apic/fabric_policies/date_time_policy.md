# Date and Time Policy

Location in GUI:
`Fabric` » `Fabric Policies` » `Fabric Policies` » `Policies` » `Pod` » `Date and Time`


{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  fabric_policies:
    pod_policies:
      date_time_policies:
        - name: NTP1
          ntp_servers:
            - hostname_ip: 1.1.1.13
```

Full example:

```yaml
apic:
  fabric_policies:
    pod_policies:
      date_time_policies:
        - name: NTP1
          ntp_admin_state: true
          ntp_auth_state: false
          apic_ntp_server_state: false
          apic_ntp_server_master_mode: false
          apic_ntp_server_master_stratum: 8
          ntp_servers:
            - hostname_ip: 1.1.1.13
              auth_key_id: 1
              preferred: true
              mgmt_epg: oob
          ntp_keys:
            - id: 1
              key: key1
              auth_type: md5
              trusted: false
```
