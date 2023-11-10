<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-igmp-interface-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-igmp-interface-policy/actions/workflows/test.yml)

# Terraform ACI IGMP Interface Policy Module

Manages ACI IGMP Interface Policy Module

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `IGMP Interface`

## Examples

```hcl
module "aci_igmp_interface_policy" {
  source  = "netascode/igmp-interface-policy/aci"
  version = ">= 0.1.0"

  name                              = "ABC"
  tenant                            = "TEN1"
  description                       = "My IGMP Interface Policy"
  grp_timeout                       = 10
  allow_v3_asm                      = true
  fast_leave                        = true
  report_link_local_groups          = true
  last_member_count                 = 5
  last_member_response_time         = 5
  querier_timeout                   = 10
  query_interval                    = 10
  robustness_variable               = 3
  query_response_interval           = 7
  startup_query_count               = 7
  startup_query_interval            = 7
  version_                          = "v3"
  report_policy_multicast_route_map = "RM1"
  static_report_multicast_route_map = "RM2"
  max_mcast_entries                 = 1000
  reserved_mcast_entries            = 100
  state_limit_multicast_route_map   = "RM3"
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
| <a name="input_name"></a> [name](#input\_name) | IGMP interface policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | IGMP interface policy description. | `string` | `""` | no |
| <a name="input_grp_timeout"></a> [grp\_timeout](#input\_grp\_timeout) | IGMP interface policy group timeout. Allowed values between 3-65535. | `number` | `260` | no |
| <a name="input_allow_v3_asm"></a> [allow\_v3\_asm](#input\_allow\_v3\_asm) | IGMP interface policy flag for Any-source multicast (ASM) v3. | `bool` | `false` | no |
| <a name="input_fast_leave"></a> [fast\_leave](#input\_fast\_leave) | IGMP interface policy flag for fast leave. | `bool` | `false` | no |
| <a name="input_report_link_local_groups"></a> [report\_link\_local\_groups](#input\_report\_link\_local\_groups) | IGMP interface policy flag for link local groups report. | `bool` | `false` | no |
| <a name="input_last_member_count"></a> [last\_member\_count](#input\_last\_member\_count) | IGMP interface policy last member query count. Allowed values between 1-5. | `number` | `2` | no |
| <a name="input_last_member_response_time"></a> [last\_member\_response\_time](#input\_last\_member\_response\_time) | IGMP interface policy last member response time. Allowed values between 1-25. | `number` | `1` | no |
| <a name="input_querier_timeout"></a> [querier\_timeout](#input\_querier\_timeout) | IGMP interface policy querier timeout. Allowed values between 1-255. | `number` | `255` | no |
| <a name="input_query_interval"></a> [query\_interval](#input\_query\_interval) | IGMP interface policy querier interval. Allowed values between 1-18000. | `number` | `125` | no |
| <a name="input_robustness_variable"></a> [robustness\_variable](#input\_robustness\_variable) | IGMP interface policy robustness factor. Allowed values between 1-7. | `number` | `2` | no |
| <a name="input_query_response_interval"></a> [query\_response\_interval](#input\_query\_response\_interval) | IGMP interface policy query response interval. Allowed values between 1-25. | `number` | `25` | no |
| <a name="input_startup_query_count"></a> [startup\_query\_count](#input\_startup\_query\_count) | IGMP interface policy startup query count. Allowed values between 1-10. | `number` | `2` | no |
| <a name="input_startup_query_interval"></a> [startup\_query\_interval](#input\_startup\_query\_interval) | IGMP interface policy startup query interval. Allowed values between 1-10. | `number` | `31` | no |
| <a name="input_version_"></a> [version\_](#input\_version\_) | IGMP interface policy startup query count. Allowed values `v2` or `v3`. | `string` | `"v2"` | no |
| <a name="input_report_policy_multicast_route_map"></a> [report\_policy\_multicast\_route\_map](#input\_report\_policy\_multicast\_route\_map) | IGMP interface policy report multicast route-map. | `string` | `""` | no |
| <a name="input_static_report_multicast_route_map"></a> [static\_report\_multicast\_route\_map](#input\_static\_report\_multicast\_route\_map) | IGMP interface policy static report multicast route-map. | `string` | `""` | no |
| <a name="input_max_mcast_entries"></a> [max\_mcast\_entries](#input\_max\_mcast\_entries) | IGMP interface policy maximum number of multicast entries. Allowed values 1-4294967295 or `unlimited`. | `string` | `"unlimited"` | no |
| <a name="input_reserved_mcast_entries"></a> [reserved\_mcast\_entries](#input\_reserved\_mcast\_entries) | IGMP interface policy number of reserved multicast entries. Allowed values 0-4294967295 or `undefined`. | `string` | `"undefined"` | no |
| <a name="input_state_limit_multicast_route_map"></a> [state\_limit\_multicast\_route\_map](#input\_state\_limit\_multicast\_route\_map) | IGMP interface policy state limit multicast route-map. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `igmpIfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | IGMP interface policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.igmpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.igmpRepPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.igmpStRepPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.igmpStateLPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_report_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_state_limit](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_static_report](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->