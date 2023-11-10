<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-bgp-timer-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-bgp-timer-policy/actions/workflows/test.yml)

# Terraform ACI BGP Timer Policy Module

Manages ACI BGP Timer Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BGP` » `BGP Timers`

## Examples

```hcl
module "aci_bgp_timer_policy" {
  source  = "netascode/bgp-timer-policy/aci"
  version = ">= 0.1.0"

  tenant                  = "ABC"
  name                    = "BGP1"
  description             = "My Description"
  graceful_restart_helper = false
  hold_interval           = 60
  keepalive_interval      = 30
  maximum_as_limit        = 20
  stale_interval          = "120"
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
| <a name="input_name"></a> [name](#input\_name) | BGP timer policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_graceful_restart_helper"></a> [graceful\_restart\_helper](#input\_graceful\_restart\_helper) | Graceful restart helper. | `bool` | `true` | no |
| <a name="input_hold_interval"></a> [hold\_interval](#input\_hold\_interval) | Hold interval. Allowed values: 0, 3-3600. | `number` | `180` | no |
| <a name="input_keepalive_interval"></a> [keepalive\_interval](#input\_keepalive\_interval) | Keepalive interval. Minimum value: 0. Maximum value: 3600. | `number` | `60` | no |
| <a name="input_maximum_as_limit"></a> [maximum\_as\_limit](#input\_maximum\_as\_limit) | Maximum AS limit. Minimum value: 0. Maximum value: 2000. | `number` | `0` | no |
| <a name="input_stale_interval"></a> [stale\_interval](#input\_stale\_interval) | Stale interval. Allowed values: `default` or a number between 1 and 3600. | `string` | `"default"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `bgpCtxPol` object. |
| <a name="output_name"></a> [name](#output\_name) | BGP timer policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.bgpCtxPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->