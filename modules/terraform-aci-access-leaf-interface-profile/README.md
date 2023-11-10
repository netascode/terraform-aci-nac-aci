<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-access-leaf-interface-profile/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-access-leaf-interface-profile/actions/workflows/test.yml)

# Terraform ACI Access Leaf Interface Profile Module

Manages ACI Access Leaf Interface Profile

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Leaf Interfaces` » `Profiles`

## Examples

```hcl
module "aci_access_leaf_interface_profile" {
  source  = "netascode/access-leaf-interface-profile/aci"
  version = ">= 0.1.0"

  name = "INT-PROF1"
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
| <a name="input_name"></a> [name](#input\_name) | Leaf interface profile name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraAccPortP` object. |
| <a name="output_name"></a> [name](#output\_name) | Leaf interface profile name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.infraAccPortP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->