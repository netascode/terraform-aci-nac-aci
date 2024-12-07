<!-- BEGIN_TF_DOCS -->
# Terraform ACI MACsec Interfaces Policy Module

Manages ACI MACsec Interfaces Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `MACsec` » `Interfaces`

## Examples

```hcl
module "aci_macsec_interfaces_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-macsec-interfaces-policy"
  version = ">= 0.9.2"

  name                     = "macsec-int-pol"
  admin_state              = true
  macsec_parameters_policy = "macsec-parameter-policy"
  macsec_keychain_policy   = "macsec-keychain-policy"
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
| <a name="input_name"></a> [name](#input\_name) | MACsec Interface Policy Name | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | MACsec Interface Policy description | `string` | `""` | no |
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | The administrative state of the MACsec Interface Policy | `bool` | `true` | no |
| <a name="input_macsec_parameters_policy"></a> [macsec\_parameters\_policy](#input\_macsec\_parameters\_policy) | MACsec Parameters Policy Name | `string` | n/a | yes |
| <a name="input_macsec_keychain_policy"></a> [macsec\_keychain\_policy](#input\_macsec\_keychain\_policy) | MACsec KeyChain Policy Name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | MACsec Interface Policy dn |
| <a name="output_name"></a> [name](#output\_name) | MACsec Interface Policy name |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.macsecIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.macsecRsToKeyChainPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.macsecRsToParamPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->