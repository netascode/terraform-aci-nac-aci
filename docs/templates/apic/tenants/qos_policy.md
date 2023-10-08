# QoS Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `Custom QoS`

{{ doc_gen }}

### Examples

```yaml
apic:
  tenants:
    - name: ABC
      policies:
        qos:
          - name: QOS_POLICY
            dscp_priority_maps:
              - priority: level2
                dscp_from: AF11
                dscp_to: AF12
                cos_target: 1
                dscp_target: AF11
            dot1p_classifiers:
              - priority: level3
                dot1p_from: 1
                dot1p_to: 2
                dscp_target: CS2
```
