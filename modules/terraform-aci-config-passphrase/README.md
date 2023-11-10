<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-config-passphrase/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-config-passphrase/actions/workflows/test.yml)

# Terraform ACI Config Passphrase Module

Manages Config Passphrase

Location in GUI:
`System` » `System Settings` » `Global AES Passphrase Encryption Settings`

## Examples

```hcl
module "aci_config_passphrase" {
  source  = "netascode/config-passphrase/aci"
  version = ">= 0.1.0"

  config_passphrase = "Cisco123!Cisco123!"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_passphrase"></a> [config\_passphrase](#input\_config\_passphrase) | Config passphrase. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `pkiExportEncryptionKey` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.pkiExportEncryptionKey](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->