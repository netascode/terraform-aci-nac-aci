<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-access-leaf-switch-policy-group/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-access-leaf-switch-policy-group/actions/workflows/test.yml)

# Terraform ACI Access Leaf Switch Policy Group Module

Manages ACI Access Leaf Switch Policy Group

Location in GUI:
`Fabric` » `Access Policies` » `Switches` » `Leaf Switches` » `Policy Groups`

## Examples

```hcl
module "aci_access_leaf_switch_policy_group" {
  source  = "netascode/access-leaf-switch-policy-group/aci"
  version = ">= 0.1.0"

  name                    = "SW-PG1"
  forwarding_scale_policy = "HIGH-DUAL-STACK"
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
| <a name="input_name"></a> [name](#input\_name) | Leaf switch policy group name. | `string` | n/a | yes |
| <a name="input_forwarding_scale_policy"></a> [forwarding\_scale\_policy](#input\_forwarding\_scale\_policy) | Forwarding scale policy name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraAccNodePGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | Leaf switch policy group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.infraAccNodePGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsTopoctrlFwdScaleProfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->