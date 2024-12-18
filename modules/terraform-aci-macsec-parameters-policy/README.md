<!-- BEGIN_TF_DOCS -->
# Terraform ACI MACsec Parameters Policy Module

Manages ACI MACsec Parameters Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `MACsec` » `Parameters`

## Examples

```hcl
module "aci_macsec_parameters_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-macsec-parameters-policy"
  version = ">= 0.9.2"

  name                   = "macsecparam1"
  description            = "macsecparam1 description"
  confidentiality_offset = "offset-30"
  key_server_priority    = 128
  cipher_suite           = "gcm-aes-128"
  window_size            = 1024
  key_expiry_time        = 120
  security_policy        = "must-secure"
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
| <a name="input_name"></a> [name](#input\_name) | MACsec Parameter Policy Name | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | MACsec Parameter Policy description | `string` | n/a | yes |
| <a name="input_cipher_suite"></a> [cipher\_suite](#input\_cipher\_suite) | Ciper Suite. Choices: `gcm-aes-128`, `gcm-aes-256`, `gcm-aes-xpn-128`, `gcm-aes-xpn-256`.  Deafult is `gcm-aes-xpn-256`. | `string` | `"gcm-aes-xpn-256"` | no |
| <a name="input_confidentiality_offset"></a> [confidentiality\_offset](#input\_confidentiality\_offset) | Confidentiality Offset. Choices: `offset-0`, `offset-30`, `offset-50`. Default is `offset-0`. | `string` | `"offset-0"` | no |
| <a name="input_key_server_priority"></a> [key\_server\_priority](#input\_key\_server\_priority) | Key Server Priority. Minimum value: `0`. Maximum value: `255`. Default: `16` | `number` | `16` | no |
| <a name="input_window_size"></a> [window\_size](#input\_window\_size) | Replay Protection Window Size. Minimum value: `0`. Maximum value `4294967295`. Default: `64` | `number` | `64` | no |
| <a name="input_key_expiry_time"></a> [key\_expiry\_time](#input\_key\_expiry\_time) | SAK Expiry Time (in seconds). Values are `0` (disabled); or Minimum value `60`, Maximum value `2592000` | `number` | `0` | no |
| <a name="input_security_policy"></a> [security\_policy](#input\_security\_policy) | Security Policy. Choices are: `must-secure` or `should-secure`. | `string` | `"should-secure"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | MACsec Parameter Policy name |
| <a name="output_dn"></a> [dn](#output\_dn) | MACsec Parameter Policy dn |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.macsecParamPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->