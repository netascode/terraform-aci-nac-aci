<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-bgp-peer-prefix-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-bgp-peer-prefix-policy/actions/workflows/test.yml)

# Terraform ACI BGP Peer Prefix Policy Module

Manages ACI BGP Peer Prefix Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BGP` » `BGP Peer Prefix`

## Examples

```hcl
module "aci_bgp_peer_prefix_policy" {
  source  = "netascode/bgp-peer-prefix-policy/aci"
  version = ">= 0.1.0"

  name         = "ABC"
  tenant       = "TEN1"
  description  = "My BGP Peer Prefix Policy"
  action       = "restart"
  max_prefixes = 10000
  restart_time = 5000
  threshold    = 90
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
| <a name="input_name"></a> [name](#input\_name) | BGP peer prefix policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | BGP peer prefix policy description. | `string` | `""` | no |
| <a name="input_action"></a> [action](#input\_action) | BGP peer prefix policy action. Valid values are `reject`, `log`, `restart` or `shut`. | `string` | `"reject"` | no |
| <a name="input_max_prefixes"></a> [max\_prefixes](#input\_max\_prefixes) | BGP peer prefix policy maximun number of prefixes. Allowed values: 1-300000. | `number` | `20000` | no |
| <a name="input_restart_time"></a> [restart\_time](#input\_restart\_time) | BGP peer prefix policy restart time. Allowed values are `infinite` or a number between 1 and 65535. | `string` | `"infinite"` | no |
| <a name="input_threshold"></a> [threshold](#input\_threshold) | BGP peer prefix policy threshold. Allowed values: 1 and 100. | `number` | `75` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `bgpPeerPfxPol` object. |
| <a name="output_name"></a> [name](#output\_name) | BGP Peer Prefix Policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.bgpPeerPfxPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->