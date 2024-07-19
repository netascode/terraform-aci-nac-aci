# NetFlow Records

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `NetFlow` » `NetFlow Records`

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      netflow_records:
        - name: RECORD1
          description: record 1
          match_parameters:
            - dst-ip
            - src-ip
            - dst-port
            - src-port 
```
