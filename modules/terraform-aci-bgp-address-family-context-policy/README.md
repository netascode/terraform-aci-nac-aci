<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-bgp-address-family-context-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-bgp-address-family-context-policy/actions/workflows/test.yml)

# Terraform ACI BGP Address Family Context Module

Manages ACI BGP Address Family Context

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BGP` » `BGP Address Family Context`

## Examples

```hcl
module "aci_bgp_address_family_context_policy" {
  source  = "netascode/bgp-address-family-context-policy/aci"
  version = ">= 0.1.0"

  name                   = "ABC"
  tenant                 = "TEN1"
  description            = "My BGP Policy"
  enable_host_route_leak = true
  ebgp_distance          = 21
  ibgp_distance          = 201
  local_distance         = 221
  local_max_ecmp         = 4
  ebgp_max_ecmp          = 8
  ibgp_max_ecmp          = 8
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
| <a name="input_name"></a> [name](#input\_name) | BGP Address Family Context Policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | BGP Address Family Context Policy description. | `string` | `""` | no |
| <a name="input_enable_host_route_leak"></a> [enable\_host\_route\_leak](#input\_enable\_host\_route\_leak) | Flag to enable host route leaking. | `bool` | `false` | no |
| <a name="input_ebgp_distance"></a> [ebgp\_distance](#input\_ebgp\_distance) | eBGP Distance. Allowed values `ebgp_distance`: 1-255. | `number` | `20` | no |
| <a name="input_ibgp_distance"></a> [ibgp\_distance](#input\_ibgp\_distance) | iBGP Distance. Allowed values `ibgp_distance`: 1-255. | `number` | `200` | no |
| <a name="input_local_distance"></a> [local\_distance](#input\_local\_distance) | Local Distance. Allowed values `local_distance`: 1-255. | `number` | `220` | no |
| <a name="input_local_max_ecmp"></a> [local\_max\_ecmp](#input\_local\_max\_ecmp) | Local Maximum ECMP. Allowed values `local_max_ecmp`: 1-255. | `number` | `0` | no |
| <a name="input_ebgp_max_ecmp"></a> [ebgp\_max\_ecmp](#input\_ebgp\_max\_ecmp) | eBGP Maximum ECMP. Allowed values `ebgp_max_ecmp`: 1-255. | `number` | `16` | no |
| <a name="input_ibgp_max_ecmp"></a> [ibgp\_max\_ecmp](#input\_ibgp\_max\_ecmp) | iBGP Maximum ECMP. Allowed values `ibgp_max_ecmp`: 1-255. | `number` | `16` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `bgpCtxAfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | BGP Address Family Context Policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.bgpCtxAfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->