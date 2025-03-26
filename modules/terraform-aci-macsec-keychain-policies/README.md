<!-- BEGIN_TF_DOCS -->
# Terraform ACI MACsec Keychain Policies Module

Manages ACI MACsec Keychain Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `MACsec` » `MACsec KeyChain Policies`

## Examples

```hcl
module "aci_macsec_keychain_policies" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-macsec-keychain-policies"
  version = ">= 0.9.2"

  name        = "macsec-keychain-pol"
  description = "Keychain Description"
  key_policies = [{
    name           = "keypolicy1"
    description    = "Key Policy Description"
    key_name       = "deadbeef9898765431"
    pre_shared_key = "abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234"
    start_time     = "now"
    end_time       = "infinite"
  }]
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
| <a name="input_name"></a> [name](#input\_name) | MACsec Key Policy Name | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | MACsec Policy description | `string` | `""` | no |
| <a name="input_key_policies"></a> [key\_policies](#input\_key\_policies) | Key Polices for Key Chain | <pre>list(object({<br/>    name           = string<br/>    key_name       = string<br/>    pre_shared_key = string<br/>    description    = optional(string, "")<br/>    start_time     = optional(string, "now")<br/>    end_time       = optional(string, "infinite")<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | MACsec KeyChain Policy name |
| <a name="output_dn"></a> [dn](#output\_dn) | MACsec KeyChain Policy dn |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.macsecKeyChainPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.macsecKeyPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->