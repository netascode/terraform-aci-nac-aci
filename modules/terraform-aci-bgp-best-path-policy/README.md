<!-- BEGIN_TF_DOCS -->
# Terraform ACI BGP Best Path Policy Module

Manages ACI BGP Best Path Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BGP` » `BGP Best Path Policy`

## Examples

```hcl
module "aci_bgp_best_path_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bgp-best-path-policy"
  version = ">= 0.8.0"

  name                    = "ABC"
  tenant                  = "TEN1"
  description             = "My BGP Best Path Policy"
  as_path_multipath_relax = true
  ignore_igp_metric       = false
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
| <a name="input_as_path_multipath_relax"></a> [as\_path\_multipath\_relax](#input\_as\_path\_multipath\_relax) | Flag to Relax AS-Path restriction. | `bool` | `false` | no |
| <a name="input_ignore_igp_metric"></a> [ignore\_igp\_metric](#input\_ignore\_igp\_metric) | Flag to Ignore IGP metric. | `bool` | `false` | no |

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