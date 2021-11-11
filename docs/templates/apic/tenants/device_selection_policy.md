# Device Selection Policy

Description

{{ aac_doc }}
### Examples

```yaml
apic:
  tenants:
    - name: ABC
      services:
        device_selection_policies:
          - contract: CON1
            service_graph_template: TEMPLATE1
            consumer:
              l3_destination: enabled
              permit_logging: disabled
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
