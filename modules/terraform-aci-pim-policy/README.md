<!-- BEGIN_TF_DOCS -->
# Terraform ACI PIM Policy Module

Manages ACI PIM Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `PIM`

## Examples

```hcl
module "aci_pim_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-im-policy"
  version = ">= 0.8.0"

  name                         = "ABC"
  tenant                       = "PIM1"
  auth_key                     = "myKey"
  auth_type                    = "ah-md5"
  mcast_dom_boundary           = true
  passive                      = true
  strict_rfc                   = true
  designated_router_delay      = 6
  designated_router_priority   = 5
  hello_interval               = 10
  join_prune_interval          = 120
  neighbor_filter_policy       = "NEIGH_RM"
  join_prune_filter_policy_in  = "IN_RM"
  join_prune_filter_policy_out = "OUT_RM"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.15.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | PIM policy name. | `string` | n/a | yes |
| <a name="input_auth_key"></a> [auth\_key](#input\_auth\_key) | PIM policy authorization key. | `string` | `null` | no |
| <a name="input_auth_type"></a> [auth\_type](#input\_auth\_type) | PIM policy authorization type. Allowed values are: `none` or `ah-md5`. | `string` | `"none"` | no |
| <a name="input_mcast_dom_boundary"></a> [mcast\_dom\_boundary](#input\_mcast\_dom\_boundary) | PIM policy multicast domain boundary flag. | `bool` | `false` | no |
| <a name="input_passive"></a> [passive](#input\_passive) | PIM policy multicast passive flag. | `bool` | `false` | no |
| <a name="input_strict_rfc"></a> [strict\_rfc](#input\_strict\_rfc) | PIM policy Mmlticast strict RFC compliant flag. | `bool` | `false` | no |
| <a name="input_designated_router_delay"></a> [designated\_router\_delay](#input\_designated\_router\_delay) | PIM policy designated router delay (seconds). | `number` | `3` | no |
| <a name="input_designated_router_priority"></a> [designated\_router\_priority](#input\_designated\_router\_priority) | PIM policy multicast designated router priority. | `number` | `1` | no |
| <a name="input_hello_interval"></a> [hello\_interval](#input\_hello\_interval) | PIM policy multicast hello interval (milliseconds). | `number` | `30000` | no |
| <a name="input_join_prune_interval"></a> [join\_prune\_interval](#input\_join\_prune\_interval) | PIM policy join prune interval (seconds). | `number` | `60` | no |
| <a name="input_neighbor_filter_policy"></a> [neighbor\_filter\_policy](#input\_neighbor\_filter\_policy) | PIM policy interface-level neighbor filter policy. | `string` | `""` | no |
| <a name="input_join_prune_filter_policy_out"></a> [join\_prune\_filter\_policy\_out](#input\_join\_prune\_filter\_policy\_out) | PIM policy interface-level outbound join-prune filter policy. | `string` | `""` | no |
| <a name="input_join_prune_filter_policy_in"></a> [join\_prune\_filter\_policy\_in](#input\_join\_prune\_filter\_policy\_in) | PIM policy interface-level inbound join-prune filter policy. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `pimIfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | PIM Policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.pimIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimJPInbFilterPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimJPOutbFilterPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimNbrFilterPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_join_prune_filter_in](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_join_prune_filter_out](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_neighbor_filter](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->