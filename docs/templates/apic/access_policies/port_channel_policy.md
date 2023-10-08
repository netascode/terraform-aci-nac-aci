# Port Channel Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Port Channel`

### Terraform modules

* [Port Channel Policy](https://registry.terraform.io/modules/netascode/port-channel-policy/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      port_channel_policies:
        - name: LACP-ACTIVE
          mode: active
```
