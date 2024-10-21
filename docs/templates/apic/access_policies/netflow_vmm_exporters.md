# NetFlow VMM Exporters

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `NetFlow` » `NetFlow Exporters for VM Networking`

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      netflow_vmm_exporters:
        - name: VMM-EXPORTER1
          description: VM exporter 1
          source_ip: 1.1.1.1
          destination_port: 1234
          destination_ip: 2.2.2.2
```
