# Redirect Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `L4-L7 Policy-Based Redirect`


{{ doc_gen }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      services:
        redirect_policies:
          - name: PBR1
            l3_destinations:
              - ip: 1.1.1.1
                mac: 00:00:00:11:22:33
          - name: PBR_L1
            type: L1
            l1l2_destinations:
              - name: L1_DEST1
                concrete_interface:
                  l4l7_device: DEV-L1
                  concrete_device: DEV1-L1
                  interface: INT1
          - name: PBR_L2
            type: L2
            l1l2_destinations:
              - name: L2_DEST1
                concrete_interface:
                  l4l7_device: DEV-L2
                  concrete_device: DEV1-L2
                  interface: INT1
```

Full example:

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
            anycast: false
            hashing: sip-dip-prototype
            threshold: false
            max_threshold: 0
            min_threshold: 0
            threshold_down_action: permit
            resilient_hashing: false
            redirect_backup_policy: L4L7_REDIRECT_BACKUP1
            l3_destinations:
              - description: My Desc
                ip: 1.1.1.1
                ip_2:
                mac: 00:00:00:11:22:33
                pod: 1
                redirect_health_group: HEALTH_GROUP_1
          - name: PBR_L1
            alias: PBR_L1
            description: My Desc
            type: L1
            hashing: sip-dip-prototype
            resilient_hashing: false
            l1l2_destinations:
              - description: L1 destination
                name: L1_DEST1
                redirect_health_group: HEALTH_GROUP_L1
                concrete_interface:
                  l4l7_device: DEV-L1
                  concrete_device: DEV1-L1
                  interface: INT1
          - name: PBR_L2
            alias: PBR_L2
            description: My Desc
            type: L2
            hashing: sip-dip-prototype
            resilient_hashing: false
            l1l2_destinations:
              - description: L2 destination
                name: L2_DEST1
                mac: 00:00:00:11:22:34
                weight: 1
                pod: 1
                redirect_health_group: HEALTH_GROUP_L2
                concrete_interface:
                  l4l7_device: DEV-L2
                  concrete_device: DEV1-L2
                  interface: INT1
```
