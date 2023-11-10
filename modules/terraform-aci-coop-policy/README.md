<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-coop-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-coop-policy/actions/workflows/test.yml)

# Terraform ACI COOP Policy Module

Manages ACI COOP Policy

Location in GUI:
`System` » `System Settings` » `COOP Group`

## Examples

```hcl
module "aci_coop_policy" {
  source  = "netascode/coop-policy/aci"
  version = ">= 0.1.0"

  coop_group_policy = "strict"
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
| <a name="input_coop_group_policy"></a> [coop\_group\_policy](#input\_coop\_group\_policy) | COOP group policy. Choices: `compatible`, `strict`. | `string` | `"compatible"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `coopPol` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.coopPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->