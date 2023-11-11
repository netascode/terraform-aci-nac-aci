<!-- BEGIN_TF_DOCS -->
# Terraform ACI LLDP Policy Module

Manages ACI LLDP Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `LLDP Interface`

## Examples

```hcl
module "aci_lldp_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-lldp-policy"
  version = ">= 0.8.0"

  name           = "LLDP-ON"
  admin_rx_state = true
  admin_tx_state = true
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
| <a name="input_name"></a> [name](#input\_name) | LLDP interface policy name. | `string` | n/a | yes |
| <a name="input_admin_rx_state"></a> [admin\_rx\_state](#input\_admin\_rx\_state) | Administrative state receive. | `bool` | `false` | no |
| <a name="input_admin_tx_state"></a> [admin\_tx\_state](#input\_admin\_tx\_state) | Administrative state transmit. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `lldpIfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | LLDP interface policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.lldpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->