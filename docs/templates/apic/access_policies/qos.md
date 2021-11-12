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
        - level: 2
          admin_state: disabled
          mtu: 1500
          scheduling: strict-priority
          bandwidth_percent: 0
          congestion_algorithm: tail-drop
```
