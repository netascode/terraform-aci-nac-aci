# QoS Class

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Global` » `QOS Class`


{{ doc_gen }}

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
