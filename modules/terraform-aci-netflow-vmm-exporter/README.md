<!-- BEGIN_TF_DOCS -->
# Terraform ACI Netflow Exporter Module

Manages ACI Netflow Exporters

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface Policies` » `NetFlow` » `Netflow Exporters`

## Examples

```hcl
module "aci_netflow_monitor" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-netflow-exporter"
  version = ">= 0.9.0"

  name                = "EXPORTER1"
  description         = "Netflow exporter 1"
  source_type         = "custom-src-ip"
  source_ip           = "172.16.0.0/20"
  destination_port    = "1234"
  destination_ip      = "10.1.1.1"
  dscp                = "AF12"
  epg_type            = "epg"
  tenant              = "ABC"
  application_profile = "AP1"
  endpoint_group      = "EPG1"
  vrf                 = "VRF1"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Netflow Exporter name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Netflow Exporter description. | `string` | `""` | no |
| <a name="input_dscp"></a> [dscp](#input\_dscp) | Netflow Exporter DSCP. Choices: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, `unspecified` or a number between `0` and `63`. | `string` | `"unspecified"` | no |
| <a name="input_destination_ip"></a> [destination\_ip](#input\_destination\_ip) | Netflow Exporter destination address. | `string` | n/a | yes |
| <a name="input_destination_port"></a> [destination\_port](#input\_destination\_port) | Netflow Exporter destination port. | `string` | n/a | yes |
| <a name="input_source_ip"></a> [source\_ip](#input\_source\_ip) | Netflow Exporter source address. | `string` | `"0.0.0.0"` | no |
| <a name="input_source_type"></a> [source\_type](#input\_source\_type) | Netflow Exporter source type. Allowed values: `custom-src-ip`, `inband-mgmt-ip`, `oob-mgmt-ip`, `ptep`. | `string` | n/a | yes |
| <a name="input_epg_type"></a> [epg\_type](#input\_epg\_type) | Netflow Exporter EPG type. Allowed values: `epg`, `external_epg`. | `string` | `""` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Netflow Exporter tenant name. | `string` | `""` | no |
| <a name="input_application_profile"></a> [application\_profile](#input\_application\_profile) | Netflow Exporter application profile name. | `string` | `""` | no |
| <a name="input_endpoint_group"></a> [endpoint\_group](#input\_endpoint\_group) | Netflow Exporter endpoint group name. | `string` | `""` | no |
| <a name="input_vrf"></a> [vrf](#input\_vrf) | Netflow Exporter VRF name. | `string` | `""` | no |
| <a name="input_l3out"></a> [l3out](#input\_l3out) | Netflow Exporter L3out name. | `string` | `""` | no |
| <a name="input_external_endpoint_group"></a> [external\_endpoint\_group](#input\_external\_endpoint\_group) | Netflow Exporter external endpoint group name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `netflowExporterPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Netflow Exporter name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.netflowExporterPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.netflowRsExporterToCtx](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.netflowRsExporterToEPg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->