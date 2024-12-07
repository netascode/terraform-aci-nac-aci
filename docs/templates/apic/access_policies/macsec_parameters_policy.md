# MACsec Parameters Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `MACsec` » `Parameters`


{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      macsec_parameters_policies:
        - name: MACSEC_PARAM1
          description: MACSEC parameters policy 1
          confidentiality_offset: offset-30
          key_server_priority: 128
          cipher_suite: gcm-aes-256 
          window_size: 120
          security_policy: must-secure
```
