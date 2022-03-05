# PSU Switch Policy

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Switch` » `Power Supply Redundancy`

### Terraform modules

* [PSU Policy](https://registry.terraform.io/modules/netascode/psu-policy/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  fabric_policies:
    switch_policies:
      psu_policies:
        - name: COMBINED
          admin_state: combined
```
