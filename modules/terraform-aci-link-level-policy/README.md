<!-- BEGIN_TF_DOCS -->
# Terraform ACI Link Level Policy Module

Manages ACI Link Level Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Link Level`

## Examples

```hcl
module "aci_link_level_policy" {
  source  = "netascode/link-level-policy/aci"
  version = ">= 0.1.0"

  name     = "100G"
  speed    = "100G"
  auto     = true
  fec_mode = "disable-fec"
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
| <a name="input_name"></a> [name](#input\_name) | Link level interface policy name. | `string` | n/a | yes |
| <a name="input_speed"></a> [speed](#input\_speed) | Interface speed. Choices: `inherit`, `auto`, `100M`, `1G`, `10G`, `25G`, `40G`, `100G`, `400G`. | `string` | `"inherit"` | no |
| <a name="input_auto"></a> [auto](#input\_auto) | Auto negotiation. | `bool` | `true` | no |
| <a name="input_fec_mode"></a> [fec\_mode](#input\_fec\_mode) | Forward error correction (FEC) mode. Choices: `inherit`, `cl91-rs-fec`, `cl74-fc-fec`, `ieee-rs-fec`, `cons16-rs-fec`, `disable-fec`. | `string` | `"inherit"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fabricHIfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Link level interface policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricHIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->