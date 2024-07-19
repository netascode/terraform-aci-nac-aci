# NetFlow Monitors

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `NetFlow` » `NetFlow Monitors`

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      netflow_monitors:
        - name: MONITOR1
          description: monitor 1
          flow_record: RECORD1
          flow_exporters:
            - EXPORTER1
            - EXPORTER2
```
