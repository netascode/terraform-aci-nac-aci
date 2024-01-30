# Link Level Interface Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Link Level`

### Terraform modules

* [Link Level Policy](https://registry.terraform.io/modules/netascode/link-level-policy/aci/latest)

{{ doc_gen }}

### Examples

```yaml
apic:
  access_policies:
    interface_policies:
      link_level_policies:
        - name: 10G
          speed: 10G
          auto: true
          fec_mode: inherit
        - name: 10G-Copper
          speed: 10G
          auto: true
          fec_mode: inherit
          physical_media_type: sfp-10g-tx
```
