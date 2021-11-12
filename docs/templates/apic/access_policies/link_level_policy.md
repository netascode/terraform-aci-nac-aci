# Link Level Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Link Level`

### Terraform modules

* [Link Level Policy](https://registry.terraform.io/modules/netascode/link-level-policy/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      link_level_policies:
        - name: 10G
          speed: 10G
          auto: 'on'
          fec_mode: inherit
```
