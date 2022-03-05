# QoS Class

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Global` » `QOS Class`

### Terraform modules

* [QoS](https://registry.terraform.io/modules/netascode/qos/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  access_policies:
    qos:
      qos_classes:
        - level: 1
          scheduling: strict-priority
          congestion_algorithm: tail-drop
        - level: 2
          scheduling: wrr
          bandwidth_percent: 20
          congestion_algorithm: wred
```
