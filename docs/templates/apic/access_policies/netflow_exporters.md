# NetFlow Exporters

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `NetFlow` » `NetFlow Exporters`

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      netflow_exporters:
        - name: EXPORTER1
          description: exporter 1
          source_type: custom-src-ip
          source_ip: 1.1.1.1/20
          destination_port: 1234
          destination_ip: 2.2.2.2
          dscp: AF11
          epg_type: epg
          tenant: ABC
          application_profile: AP1
          endpoint_group: EPG1
          vrf: VRF1
```
