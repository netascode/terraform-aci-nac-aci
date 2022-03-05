# Device Selection Policy

Location in GUI:
`Tenants` » `XXX` » `Services` » `L4-L7` » `Device Selection Policies`

### Terraform modules

* [Device Selection Policy](https://registry.terraform.io/modules/netascode/device-selection-policy/aci/latest)

{{ aac_doc }}

### Examples

Simple example:

```yaml
apic:
  tenants:
    - name: ABC
      services:
        device_selection_policies:
          - contract: CON1
            service_graph_template: TEMPLATE1
            consumer:
              redirect_policy:
                name: PBR1
              logical_interface: INT1
              bridge_domain:
                name: BD1
            provider:
              redirect_policy:
                name: PBR1
              logical_interface: INT1
              bridge_domain:
                name: BD1
```

Full example:

```yaml
apic:
  tenants:
    - name: ABC
      services:
        device_selection_policies:
          - contract: CON1
            service_graph_template: TEMPLATE1
            consumer:
              l3_destination: true
              permit_logging: false
              redirect_policy:
                name: PBR1
              logical_interface: INT1
              bridge_domain:
                name: BD1
              service_epg_policy: SERVICE_EPG1
              custom_qos_policy: QOS_POLICY
            provider:
              redirect_policy:
                name: PBR1
              logical_interface: INT1
              bridge_domain:
                name: BD1
              service_epg_policy: SERVICE_EPG2
              custom_qos_policy: QOS_POLICY
```
