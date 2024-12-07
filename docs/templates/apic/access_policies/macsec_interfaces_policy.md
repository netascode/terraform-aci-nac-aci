# MACsec Interfaces Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `MACsec` » `Interfaces`


{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      macsec_interfaces_policies:
        - name: MACSEC_INT1
          description: MACSEC Interfaces Policy 1
          admin_state: true
          macsec_parameters_policy: MACSEC_PARAM1
          macsec_keychain_policy: MACSEC_KEYCHAIN1
```
