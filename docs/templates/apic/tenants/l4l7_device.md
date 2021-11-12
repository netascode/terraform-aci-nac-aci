# L4L7 Device

Location in GUI:
`Tenants` » `XXX` » `Services` » `L4-L7` » `Devices`

### Terraform modules

* [L4L7 Device](https://registry.terraform.io/modules/netascode/l4l7-device/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      services:
        l4l7_devices:
          - name: DEV1
            alias: DEV1-ALIAS
            context_aware: single-Context
            type: PHYSICAL
            function: GoTo
            copy_device: 'no'
            managed: 'no'
            promiscuous_mode: 'no'
            service_type: FW
            trunking: 'no'
            physical_domain: PHY1
            concrete_devices:
              - name: DEV1
                alias: DEV1-ALIAS
                vcenter_name:
                vm_name:
                interfaces:
                  - name: INT1
                    alias: INT1-ALIAS
                    vnic_name:
                    node_id: 101
                    module: 1
                    port: 11
                  - name: INT2
                    node_id: 101
                    fex_id: 101
                    port: 13
            logical_interfaces:
              - name: INT1
                alias: INT1-ALIAS
                vlan: 135
                concrete_interfaces:
                  - device: DEV1
                    interface_name: INT1
```
