# Fabric Wide Settings

Location in GUI:
`System` » `System Settings` » `Fabric-Wide Settings`

### Terraform modules

* [Fabric Wide Settings](https://registry.terraform.io/modules/netascode/fabric-wide-settings/aci/latest)

{{ aac_doc }}

### Examples

```yaml
apic:
  fabric_policies:
    global_settings:
      domain_validation: false
      enforce_subnet_check: false
      opflex_authentication: true
      disable_remote_endpoint_learn: true
      overlapping_vlan_validation: true
      remote_leaf_direct: true
      reallocate_gipo: true

```
