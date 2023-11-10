<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-access-spine-interface-profile/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-access-spine-interface-profile/actions/workflows/test.yml)

# Terraform ACI Access Spine Interface Profile Module

Manages ACI Access Spine Interface Profile

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Spine Interfaces` » `Profiles`

## Examples

```hcl
module "aci_access_spine_interface_profile" {
  source  = "netascode/access-spine-interface-profile/aci"
  version = ">= 0.1.0"

  name = "SPINE1001"
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
| <a name="input_name"></a> [name](#input\_name) | Spine interface profile name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraSpAccPortP` object. |
| <a name="output_name"></a> [name](#output\_name) | Spine interface profile name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.infraSpAccPortP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->