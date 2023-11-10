<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-bgp-best-path-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-bgp-best-path-policy/actions/workflows/test.yml)

# Terraform ACI BGP Best Path Policy Module

Manages ACI BGP Best Path Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BGP` » `BGP Best Path Policy`

## Examples

```hcl
module "aci_bgp_best_path_policy" {
  source  = "netascode/bgp-best-path-policy/aci"
  version = ">= 0.1.0"

  name         = "ABC"
  tenant       = "TEN1"
  description  = "My BGP Best Path Policy"
  control_type = "multi-path-relax"
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
| <a name="input_name"></a> [name](#input\_name) | BGP best path policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | BGP best path policy description. | `string` | `""` | no |
| <a name="input_control_type"></a> [control\_type](#input\_control\_type) | BGP best path policy control type. Allowed value: `multi-path-relax`. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `bgpBestPathCtrlPol` object. |
| <a name="output_name"></a> [name](#output\_name) | BGP best path policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.bgpBestPathCtrlPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->