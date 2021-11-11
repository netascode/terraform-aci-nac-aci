# VMware VMM Domain

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  fabric_policies:
    vmware_vmm_domains:
      - name: VMM1
        access_mode: read-write
        delimiter: '|'
        tag_collection: 'yes'
        vlan_pool: VMM1
        vswitch:
          cdp_policy: CDP-ENABLED
          lldp_policy: LLDP-ENABLED
          port_channel_policy: LACP-ACTIVE
        credential_policies:
          - name: CRED1
            username: Administrator
            password: C1sco123
        vcenters:
          - name: VC
            hostname_ip: 10.10.10.10
            datacenter: DC1
            dvs_version: unmanaged
            statistics: enabled
            credential_policy: CRED1
```
