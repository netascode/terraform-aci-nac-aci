<!-- BEGIN_TF_DOCS -->
# Terraform ACI Data Plane Plane Policing Module

Manages Data Plane Policing Policies

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Data Plane Policing`
`Tenants` » `Tenant Name` » `Policies` » `Protocol` » `Data Plane Policing`

## Examples

```hcl
module "aci_data_plane_policing_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-data-aci-data-plane-policing-policy"
  version = ">= 0.8.0"

  name            = "dpp-pol1"
  adminSt         = true
  type            = "1R2C"
  mode            = "bits"
  sharingMode     = "dedicated"
  peak_rate       = "10"
  peak_rateUnit   = "giga"
  rate            = "9"
  rateUnit        = "giga"
  be              = "9100"
  beUnit          = "mega"
  burst           = "0"
  burstUnit       = "unspecified"
  conformAction   = "transmit"
  conformMarkCos  = "unspecified"
  conformMarkDscp = "unspecified"
  exceedAction    = "mark"
  exceedMarkCos   = "3"
  exceedMarkDscp  = "18"
  violateAction   = "mark"
  violateMarkCos  = "2"
  violateMarkDscp = "38"
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
| <a name="input_name"></a> [name](#input\_name) | Name of Data Plane Policing policy. | `string` | n/a | yes |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant for Data Plane Policing policy. | `string` | `null` | no |
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | Administrative state of Data Plane Policing policy. | `bool` | `true` | no |
| <a name="input_type"></a> [type](#input\_type) | Policer Type. Allowed Values: `1R2C` or `2R3C`. | `string` | `"1R2C"` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | Policer Mode.  Allowed Values: `bit` or `packet`. | `string` | `"bit"` | no |
| <a name="input_sharing_mode"></a> [sharing\_mode](#input\_sharing\_mode) | Policer sharing mode. Allowed Values: `shared` or `dedicated`. | `string` | `"dedicated"` | no |
| <a name="input_peak_rate"></a> [peak\_rate](#input\_peak\_rate) | Peak Information Rate (2R3C policer only). Allowed Values: A number between 0 and 4,398,046,510,080. | `number` | n/a | yes |
| <a name="input_peak_rate_unit"></a> [peak\_rate\_unit](#input\_peak\_rate\_unit) | Peak Rate Unit. Allowed Values: `unspecified`, `kilo`, `mega`, `giga`. | `string` | `"unspecified"` | no |
| <a name="input_rate"></a> [rate](#input\_rate) | Committed Information Rate. Allowed Values: A number between 0 and 4,398,046,510,080. | `number` | n/a | yes |
| <a name="input_rate_unit"></a> [rate\_unit](#input\_rate\_unit) | Committed Rate Unit. Allowed Values: `unspecified`, `kilo`, `mega`, `giga`. | `string` | `"unspecified"` | no |
| <a name="input_burst_excessive"></a> [burst\_excessive](#input\_burst\_excessive) | Excessive burst size (2R3C policer only). Allowed Values: `unspecified`, or a number between 0 and 549,755,813,760. | `string` | `"unspecified"` | no |
| <a name="input_burst_excessive_unit"></a> [burst\_excessive\_unit](#input\_burst\_excessive\_unit) | Excessive Burst unit.  Allowed values: `unspecified`, `byte`, `kilo`, `mega`, `giga`, `msec`, `usec`. | `string` | `"unspecified"` | no |
| <a name="input_burst"></a> [burst](#input\_burst) | Committed burst size. Allowed Values: `unspecified`, or a number between 0 and 549,755,813,760. | `string` | `"unspecified"` | no |
| <a name="input_burst_unit"></a> [burst\_unit](#input\_burst\_unit) | Burst unit.  Allowed values: `unspecified`, `kilo`, `mega`, `giga`, `msec`, `usec`. | `string` | `"unspecified"` | no |
| <a name="input_conform_action"></a> [conform\_action](#input\_conform\_action) | Conform Action. Allowed Values: `transmit`, `drop`, or `mark`. | `string` | `"transmit"` | no |
| <a name="input_conform_mark_cos"></a> [conform\_mark\_cos](#input\_conform\_mark\_cos) | Conform Mark COS.  Allowed Values: `unspecified` or a number between 0 and 7. | `string` | `"unspecified"` | no |
| <a name="input_conform_mark_dscp"></a> [conform\_mark\_dscp](#input\_conform\_mark\_dscp) | Conform Mark Dscp. Allowed values are `unspecified` or a number between 0 and 63. | `string` | `"unspecified"` | no |
| <a name="input_exceed_action"></a> [exceed\_action](#input\_exceed\_action) | Exceed Action. Allowed Values: `transmit`, `drop`, or `mark`. | `string` | `"transmit"` | no |
| <a name="input_exceed_mark_cos"></a> [exceed\_mark\_cos](#input\_exceed\_mark\_cos) | Exceed Mark COS.  Allowed Values: `unspecified` or a number between 0 and 7. | `string` | `"unspecified"` | no |
| <a name="input_exceed_mark_dscp"></a> [exceed\_mark\_dscp](#input\_exceed\_mark\_dscp) | Conform Mark Dscp. Allowed values are `unspecified` or a number between 0 and 63. | `string` | `"unspecified"` | no |
| <a name="input_violate_action"></a> [violate\_action](#input\_violate\_action) | Violate Action. Allowed Values: `transmit`, `drop`, or `mark`. | `string` | `"transmit"` | no |
| <a name="input_violate_mark_cos"></a> [violate\_mark\_cos](#input\_violate\_mark\_cos) | Violate Mark COS.  Allowed Values: `unspecified` or a number between 0 and 7. | `string` | `"unspecified"` | no |
| <a name="input_violate_mark_dscp"></a> [violate\_mark\_dscp](#input\_violate\_mark\_dscp) | Conform Mark Dscp. Allowed values are `unspecified` or a number between 0 and 63. | `string` | `"unspecified"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `qosDppPol` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.qosDppPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->