<!-- BEGIN_TF_DOCS -->
# Terraform ACI SR MPLS Global Configuration

Description

Location in GUI:
`Tenants` » `infra` » `Policies` » `Protocol` » `MPLS Global Configuration`

## Examples

```hcl
module "aci_sr_mpls_global_configuration" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-sr-mpls-global-configuration"
  version = ">= 0.0.1"

  sr_global_block_minimum = 16000
  sr_global_block_maximum = 275999
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
| <a name="input_sr_global_block_minimum"></a> [sr\_global\_block\_minimum](#input\_sr\_global\_block\_minimum) | SR Global Block Minimum. Minimum value: 16000. Maximum value: 471804. | `number` | n/a | yes |
| <a name="input_sr_global_block_maximum"></a> [sr\_global\_block\_maximum](#input\_sr\_global\_block\_maximum) | SR Global Block Maximum. Minimum value: 16000. Maximum value: 471804. | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `mplsSrgbLabelPol` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.mplsSrgbLabelPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->