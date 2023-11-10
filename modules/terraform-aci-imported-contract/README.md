<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-imported-contract/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-imported-contract/actions/workflows/test.yml)

# Terraform ACI Imported Contract Module

ACI Imported Contract

Location in GUI:
`Tenants` » `XXX` » `Contracts` » `Imported`

## Examples

```hcl
module "aci_imported_contract" {
  source  = "netascode/imported-contract/aci"
  version = ">= 0.1.0"

  tenant          = "ABC"
  name            = "CON1"
  source_tenant   = "DEF"
  source_contract = "CON1"
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Imported contract name. | `string` | n/a | yes |
| <a name="input_source_tenant"></a> [source\_tenant](#input\_source\_tenant) | Source contract tenant name. | `string` | n/a | yes |
| <a name="input_source_contract"></a> [source\_contract](#input\_source\_contract) | Source contract name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vzCPIf` object. |
| <a name="output_name"></a> [name](#output\_name) | Imported contract name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vzCPIf](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsIf](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->