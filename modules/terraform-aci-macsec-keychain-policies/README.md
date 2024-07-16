<!-- BEGIN_TF_DOCS -->
# Terraform ACI MACsec Keychain Policies Module

Manages ACI MACsec Keychain Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `MACsec` » `MACsec KeyChain Policies`

## Examples

```hcl
module "aci_macsec_keychain_policies" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-macsec-keychain-policies"
  version = ">= 0.8.0"

  name        = "macsec-keychain-pol"
  description = "Keychain Description"
  key_policies = [{
    name         = "keypolicy1"
    description  = "Key Policy Description"
    keyName      = "deadbeef9898765431"
    preSharedKey = "abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234"
    startTime    = "now"
    endTime      = "infinite"
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
| <a name="input_name"></a> [name](#input\_name) | MACsec Key Policy Name | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | MACsec Policy description | `string` | `""` | no |
| <a name="input_key_policies"></a> [key\_policies](#input\_key\_policies) | Key Polices for Key Chain | `list(map(string))` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | MACsec KeyChain Policy name |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.macsecKeyChainPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.macsecKeyPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->