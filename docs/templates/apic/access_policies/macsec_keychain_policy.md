# MACsec Keychain Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `MACsec` » `MACsec KeyChain Policies`


{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      macsec_keychain_policies:
        - name: MACSEC_KEYCHAIN1
          description: MACSEC Keychain policy 1
          key_policies:
            - name: keypolicy1
              description: Key Policy description
              key_name: abcd1234
              pre_shared_key: abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234
              start_time: now
              end_time: '2026-07-31T16:32:21'
```
