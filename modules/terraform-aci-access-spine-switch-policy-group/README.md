<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-access-spine-switch-policy-group/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-access-spine-switch-policy-group/actions/workflows/test.yml)

# Terraform ACI Access Spine Switch Policy Group Module

Description

Location in GUI:
`Fabric` » `Access Policies` » `Switches` » `Spine Switches` » `Policy Groups`

## Examples

```hcl
module "aci_access_spine_switch_policy_group" {
  source  = "netascode/access-spine-switch-policy-group/aci"
  version = ">= 0.1.0"

  name        = "SW-PG1"
  lldp_policy = "LLDP-ON"
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
| <a name="input_name"></a> [name](#input\_name) | Spine switch policy group name. | `string` | n/a | yes |
| <a name="input_lldp_policy"></a> [lldp\_policy](#input\_lldp\_policy) | LLDP policy name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraSpineAccNodePGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | Spine switch policy group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.infraRsSpinePGrpToLldpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraSpineAccNodePGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->