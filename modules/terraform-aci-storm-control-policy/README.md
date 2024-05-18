<!-- BEGIN_TF_DOCS -->
# Terraform ACI Storm Control Policy Module

Manages ACI Storm Control Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Storm Control`

## Examples

```hcl
module "aci_storm_control_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-storm-control-policy"
  version = ">= 0.8.0"

  name                       = "SC1"
  alias                      = "SC1-ALIAS"
  description                = "My Description"
  action                     = "shutdown"
  broadcast_burst_pps        = "1000"
  broadcast_burst_rate       = "10.000000"
  broadcast_pps              = "1000"
  broadcast_rate             = "10.000000"
  multicast_burst_pps        = "1000"
  multicast_burst_rate       = "10.000000"
  multicast_pps              = "1000"
  multicast_rate             = "10.000000"
  unknown_unicast_burst_pps  = "1000"
  unknown_unicast_burst_rate = "10.000000"
  unknown_unicast_pps        = "1000"
  unknown_unicast_rate       = "10.000000"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Storm control policy name. | `string` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | Alias. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_action"></a> [action](#input\_action) | Action. Choices: `drop`, `shutdown`. | `string` | `"drop"` | no |
| <a name="input_broadcast_burst_pps"></a> [broadcast\_burst\_pps](#input\_broadcast\_burst\_pps) | Broadcast burst packets per second. | `string` | `"unspecified"` | no |
| <a name="input_broadcast_burst_rate"></a> [broadcast\_burst\_rate](#input\_broadcast\_burst\_rate) | Broadcast burst rate. | `string` | `"100.000000"` | no |
| <a name="input_broadcast_pps"></a> [broadcast\_pps](#input\_broadcast\_pps) | Broadcast packets per second. | `string` | `"unspecified"` | no |
| <a name="input_broadcast_rate"></a> [broadcast\_rate](#input\_broadcast\_rate) | Broadcast rate. | `string` | `"100.000000"` | no |
| <a name="input_multicast_burst_pps"></a> [multicast\_burst\_pps](#input\_multicast\_burst\_pps) | Multicast burst packets per second. | `string` | `"unspecified"` | no |
| <a name="input_multicast_burst_rate"></a> [multicast\_burst\_rate](#input\_multicast\_burst\_rate) | Multicast burst rate. | `string` | `"100.000000"` | no |
| <a name="input_multicast_pps"></a> [multicast\_pps](#input\_multicast\_pps) | Multicast packets per second. | `string` | `"unspecified"` | no |
| <a name="input_multicast_rate"></a> [multicast\_rate](#input\_multicast\_rate) | Multicast rate. | `string` | `"100.000000"` | no |
| <a name="input_unknown_unicast_burst_pps"></a> [unknown\_unicast\_burst\_pps](#input\_unknown\_unicast\_burst\_pps) | Unknown unicast burst packets per second. | `string` | `"unspecified"` | no |
| <a name="input_unknown_unicast_burst_rate"></a> [unknown\_unicast\_burst\_rate](#input\_unknown\_unicast\_burst\_rate) | Unknown unicast burst rate. | `string` | `"100.000000"` | no |
| <a name="input_unknown_unicast_pps"></a> [unknown\_unicast\_pps](#input\_unknown\_unicast\_pps) | Unknown unicast packets per second. | `string` | `"unspecified"` | no |
| <a name="input_unknown_unicast_rate"></a> [unknown\_unicast\_rate](#input\_unknown\_unicast\_rate) | Unknown unicast rate. | `string` | `"100.000000"` | no |
| <a name="input_burst_pps"></a> [burst\_pps](#input\_burst\_pps) | Burst packets per second for all types of traffic. | `string` | `"unspecified"` | no |
| <a name="input_burst_rate"></a> [burst\_rate](#input\_burst\_rate) | Burst rate for all types of traffic. | `string` | `"100.000000"` | no |
| <a name="input_rate_pps"></a> [rate\_pps](#input\_rate\_pps) | Rate in packets per second for all types of traffic. | `string` | `"unspecified"` | no |
| <a name="input_rate"></a> [rate](#input\_rate) | Rate for all types of traffic. | `string` | `"100.000000"` | no |
| <a name="input_configuration_type"></a> [configuration\_type](#input\_configuration\_type) | Storm control configuration type. | `string` | `"separate"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `stormctrlIfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Storm control policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.stormctrlIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->