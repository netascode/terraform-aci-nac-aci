<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-system-global-gipo/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-system-global-gipo/actions/workflows/test.yml)

# Terraform ACI System Global GIPO Module

Manages ACI System Global GIPO

Location in GUI:
`System` » `System Settings` » `System Gloval GIPo`

## Examples

```hcl
module "aci_system_global_gipo" {
  source  = "netascode/system-global-gipo/aci"
  version = ">= 0.1.0"

  use_infra_gipo = true
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
| <a name="input_use_infra_gipo"></a> [use\_infra\_gipo](#input\_use\_infra\_gipo) | Use Infra GIPo as System GIPo. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fmcastSystemGIPoPol` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fmcastSystemGIPoPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->