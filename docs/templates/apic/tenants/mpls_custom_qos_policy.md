# MPLS Custom QoS Policy

Location in GUI:
`Tenants` » `infra` » `Policies` » `Protocol` » `MPLS Custom QoS Policy`

### Terraform modules

* [MPLS Custom QoS Policy](https://registry.terraform.io/modules/netascode/mpls-custom-qos-policy/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  tenants:
    - name: infra
      policies:
        mpls_custom_qos_policies:
          - name: MPLS_QOS_POL
            description: Custom MPLS QoS Policy
            ingress_rules:
              - priority: level1
                exp_from: 1
                exp_to: 2
                dscp_target: AF11
                cos_target: 0
            egress_rules:
              - dscp_from: AF11
                dscp_to: AF12
                exp_target: 0
                cos_target: 0
```
