# VMware VMM Domain

Location in GUI:
`Virtual Networking` » `VMware`

### Terraform modules

* [VMware VMM Domain](https://registry.terraform.io/modules/netascode/vmware-vmm-domain/aci/latest)

{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  fabric_policies:
    vmware_vmm_domains:
      - name: VMM1
        vlan_pool: VMM1
        credential_policies:
          - name: CRED1
            username: Administrator
            password: C1sco123
        vcenters:
          - name: VC
            hostname_ip: 10.10.10.10
            datacenter: DC1
            credential_policy: CRED1
```

Full example:

```yaml
apic:
  fabric_policies:
    vmware_vmm_domains:
      - name: VMM1
        access_mode: read-write
        delimiter: '|'
        tag_collection: true
        vlan_pool: VMM1
        vswitch:
          cdp_policy: CDP-ENABLED
          lldp_policy: LLDP-ENABLED
          port_channel_policy: LACP-ACTIVE
          enhanced_lags:
            - name: ELAGCUSTOM
              mode: active
              lb_mode: src-dst-l4port
              num_links: 3
        credential_policies:
          - name: CRED1
            username: Administrator
            password: C1sco123
        vcenters:
          - name: VC
            hostname_ip: 10.10.10.10
            datacenter: DC1
            dvs_version: unmanaged
            statistics: true
            credential_policy: CRED1
        uplinks:
          - id: 1
            name: UPLINK1
          - id: 2
            name: UPLINK2
```
