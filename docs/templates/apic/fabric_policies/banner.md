# GUI and CLI Banner

Location in GUI:
`System` » `System Settings` » `System Alias and Banners`

### Terraform modules

* [Banner](https://registry.terraform.io/modules/netascode/banner/aci/latest)

{{ aac_doc }}
### Examples

```yaml
apic:
  fabric_policies:
    banners:
      apic_gui_alias: APIC GUI BANNER
      apic_gui_banner_url: APIC GUI BANNER URL
      apic_cli_banner: APIC CLI BANNER
      switch_cli_banner: SWITCH CLI BANNER
```
