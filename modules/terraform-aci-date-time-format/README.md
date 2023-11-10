<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-date-time-format/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-date-time-format/actions/workflows/test.yml)

# Terraform ACI Date Time Format Module

Manages ACI Date Time Format

Location in GUI:
`System` » `System Settings` » `Date and Time`

## Examples

```hcl
module "aci_date_time_format" {
  source  = "netascode/date-time-format/aci"
  version = ">= 0.1.0"

  display_format = "utc"
  timezone       = "p120_Europe-Vienna"
  show_offset    = false
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
| <a name="input_display_format"></a> [display\_format](#input\_display\_format) | Display format. Choices: `local`, `utc`. | `string` | `"local"` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Timezone. Format: `p0_UTC`. See: https://pubhub.devnetcloud.com/media/apic-mim-ref-501/docs/MO-datetimeFormat.html#tz. | `string` | `"p0_UTC"` | no |
| <a name="input_show_offset"></a> [show\_offset](#input\_show\_offset) | Show offset. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `datetimeFormat` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.datetimeFormat](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->