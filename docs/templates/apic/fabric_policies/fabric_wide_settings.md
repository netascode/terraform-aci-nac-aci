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
      domain_validation: 'no'
      enforce_subnet_check: 'no'
      opflex_authentication: 'yes'
      disable_remote_endpoint_learn: 'yes'
      overlapping_vlan_validation: 'yes'
      remote_leaf_direct: 'no'

```
