<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-device-selection-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-device-selection-policy/actions/workflows/test.yml)

# Terraform ACI Device Selection Policy Module

Manages ACI Device Selection Policy

Location in GUI:
`Tenants` » `XXX` » `Services` » `L4-L7` » `Device Selection Policies`

## Examples

```hcl
module "aci_device_selection_policy" {
  source  = "netascode/device-selection-policy/aci"
  version = ">= 0.1.1"

  tenant                                                  = "ABC"
  contract                                                = "CON1"
  service_graph_template                                  = "SGT1"
  sgt_device_name                                         = "DEV1"
  consumer_l3_destination                                 = true
  consumer_permit_logging                                 = true
  consumer_logical_interface                              = "INT1"
  consumer_redirect_policy                                = "REDIR1"
  consumer_bridge_domain                                  = "BD1"
  consumer_service_epg_policy                             = "SEPGP1"
  consumer_custom_qos_policy                              = "QOSP1"
  provider_l3_destination                                 = true
  provider_permit_logging                                 = true
  provider_logical_interface                              = "INT2"
  provider_external_endpoint_group                        = "EXTEPG1"
  provider_external_endpoint_group_l3out                  = "L3OUT1"
  provider_external_endpoint_group_redistribute_bgp       = true
  provider_external_endpoint_group_redistribute_ospf      = true
  provider_external_endpoint_group_redistribute_connected = true
  provider_external_endpoint_group_redistribute_static    = true
  provider_service_epg_policy                             = "SEPGP1"
  provider_custom_qos_policy                              = "QOSP1"
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
| <a name="input_contract"></a> [contract](#input\_contract) | Contract name. | `string` | n/a | yes |
| <a name="input_service_graph_template"></a> [service\_graph\_template](#input\_service\_graph\_template) | Service graph template name. | `string` | n/a | yes |
| <a name="input_sgt_device_tenant"></a> [sgt\_device\_tenant](#input\_sgt\_device\_tenant) | Device tenant name. | `string` | `""` | no |
| <a name="input_sgt_device_name"></a> [sgt\_device\_name](#input\_sgt\_device\_name) | Device name. | `string` | n/a | yes |
| <a name="input_consumer_l3_destination"></a> [consumer\_l3\_destination](#input\_consumer\_l3\_destination) | Consumer L3 destination. | `bool` | `false` | no |
| <a name="input_consumer_permit_logging"></a> [consumer\_permit\_logging](#input\_consumer\_permit\_logging) | Consumer permit logging. | `bool` | `false` | no |
| <a name="input_consumer_logical_interface"></a> [consumer\_logical\_interface](#input\_consumer\_logical\_interface) | Consumer logical interface. | `string` | n/a | yes |
| <a name="input_consumer_redirect_policy"></a> [consumer\_redirect\_policy](#input\_consumer\_redirect\_policy) | Consumer redirect policy name. | `string` | `""` | no |
| <a name="input_consumer_redirect_policy_tenant"></a> [consumer\_redirect\_policy\_tenant](#input\_consumer\_redirect\_policy\_tenant) | Consumer redirect policy tenant name. | `string` | `""` | no |
| <a name="input_consumer_bridge_domain"></a> [consumer\_bridge\_domain](#input\_consumer\_bridge\_domain) | Consumer bridge domain name. | `string` | `""` | no |
| <a name="input_consumer_bridge_domain_tenant"></a> [consumer\_bridge\_domain\_tenant](#input\_consumer\_bridge\_domain\_tenant) | Consumer bridge domain tenant name. | `string` | `""` | no |
| <a name="input_consumer_external_endpoint_group"></a> [consumer\_external\_endpoint\_group](#input\_consumer\_external\_endpoint\_group) | Consumer external endpoint group name. | `string` | `""` | no |
| <a name="input_consumer_external_endpoint_group_tenant"></a> [consumer\_external\_endpoint\_group\_tenant](#input\_consumer\_external\_endpoint\_group\_tenant) | Consumer external endpoint group tenant name. | `string` | `""` | no |
| <a name="input_consumer_external_endpoint_group_l3out"></a> [consumer\_external\_endpoint\_group\_l3out](#input\_consumer\_external\_endpoint\_group\_l3out) | Consumer external endpoint group l3out name. | `string` | `""` | no |
| <a name="input_consumer_external_endpoint_group_redistribute_bgp"></a> [consumer\_external\_endpoint\_group\_redistribute\_bgp](#input\_consumer\_external\_endpoint\_group\_redistribute\_bgp) | Consumer external endpoint group redistribute BGP. | `bool` | `false` | no |
| <a name="input_consumer_external_endpoint_group_redistribute_ospf"></a> [consumer\_external\_endpoint\_group\_redistribute\_ospf](#input\_consumer\_external\_endpoint\_group\_redistribute\_ospf) | Consumer external endpoint group redistribute OSPF. | `bool` | `false` | no |
| <a name="input_consumer_external_endpoint_group_redistribute_connected"></a> [consumer\_external\_endpoint\_group\_redistribute\_connected](#input\_consumer\_external\_endpoint\_group\_redistribute\_connected) | Consumer external endpoint group redistribute connected. | `bool` | `false` | no |
| <a name="input_consumer_external_endpoint_group_redistribute_static"></a> [consumer\_external\_endpoint\_group\_redistribute\_static](#input\_consumer\_external\_endpoint\_group\_redistribute\_static) | Consumer external endpoint group redistribute static. | `bool` | `false` | no |
| <a name="input_consumer_service_epg_policy"></a> [consumer\_service\_epg\_policy](#input\_consumer\_service\_epg\_policy) | Consumer service EPG policy name. | `string` | `""` | no |
| <a name="input_consumer_service_epg_policy_tenant"></a> [consumer\_service\_epg\_policy\_tenant](#input\_consumer\_service\_epg\_policy\_tenant) | Consumer service EPG policy tenant name. | `string` | `""` | no |
| <a name="input_consumer_custom_qos_policy"></a> [consumer\_custom\_qos\_policy](#input\_consumer\_custom\_qos\_policy) | Consumer custome QoS policy name. | `string` | `""` | no |
| <a name="input_provider_l3_destination"></a> [provider\_l3\_destination](#input\_provider\_l3\_destination) | Provider L3 destination. | `bool` | `false` | no |
| <a name="input_provider_permit_logging"></a> [provider\_permit\_logging](#input\_provider\_permit\_logging) | Provider permit logging. | `bool` | `false` | no |
| <a name="input_provider_logical_interface"></a> [provider\_logical\_interface](#input\_provider\_logical\_interface) | Provider logical interface. | `string` | n/a | yes |
| <a name="input_provider_redirect_policy"></a> [provider\_redirect\_policy](#input\_provider\_redirect\_policy) | Provider redirect policy name. | `string` | `""` | no |
| <a name="input_provider_redirect_policy_tenant"></a> [provider\_redirect\_policy\_tenant](#input\_provider\_redirect\_policy\_tenant) | Provider redirect policy tenant name. | `string` | `""` | no |
| <a name="input_provider_bridge_domain"></a> [provider\_bridge\_domain](#input\_provider\_bridge\_domain) | Provider bridge domain name. | `string` | `""` | no |
| <a name="input_provider_bridge_domain_tenant"></a> [provider\_bridge\_domain\_tenant](#input\_provider\_bridge\_domain\_tenant) | Provider bridge domain tenant name. | `string` | `""` | no |
| <a name="input_provider_external_endpoint_group"></a> [provider\_external\_endpoint\_group](#input\_provider\_external\_endpoint\_group) | Provider external endpoint group name. | `string` | `""` | no |
| <a name="input_provider_external_endpoint_group_tenant"></a> [provider\_external\_endpoint\_group\_tenant](#input\_provider\_external\_endpoint\_group\_tenant) | Provider external endpoint group tenant name. | `string` | `""` | no |
| <a name="input_provider_external_endpoint_group_l3out"></a> [provider\_external\_endpoint\_group\_l3out](#input\_provider\_external\_endpoint\_group\_l3out) | Provider external endpoint group l3out name. | `string` | `""` | no |
| <a name="input_provider_external_endpoint_group_redistribute_bgp"></a> [provider\_external\_endpoint\_group\_redistribute\_bgp](#input\_provider\_external\_endpoint\_group\_redistribute\_bgp) | Provider external endpoint group redistribute BGP. | `bool` | `false` | no |
| <a name="input_provider_external_endpoint_group_redistribute_ospf"></a> [provider\_external\_endpoint\_group\_redistribute\_ospf](#input\_provider\_external\_endpoint\_group\_redistribute\_ospf) | Provider external endpoint group redistribute OSPF. | `bool` | `false` | no |
| <a name="input_provider_external_endpoint_group_redistribute_connected"></a> [provider\_external\_endpoint\_group\_redistribute\_connected](#input\_provider\_external\_endpoint\_group\_redistribute\_connected) | Provider external endpoint group redistribute connected. | `bool` | `false` | no |
| <a name="input_provider_external_endpoint_group_redistribute_static"></a> [provider\_external\_endpoint\_group\_redistribute\_static](#input\_provider\_external\_endpoint\_group\_redistribute\_static) | Provider external endpoint group redistribute static. | `bool` | `false` | no |
| <a name="input_provider_service_epg_policy"></a> [provider\_service\_epg\_policy](#input\_provider\_service\_epg\_policy) | Provider service EPG policy name. | `string` | `""` | no |
| <a name="input_provider_service_epg_policy_tenant"></a> [provider\_service\_epg\_policy\_tenant](#input\_provider\_service\_epg\_policy\_tenant) | Provider service EPG policy tenant name. | `string` | `""` | no |
| <a name="input_provider_custom_qos_policy"></a> [provider\_custom\_qos\_policy](#input\_provider\_custom\_qos\_policy) | Provider custome QoS policy name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vnsLDevCtx` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vnsLDevCtx](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsLIfCtx_consumer](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsLIfCtx_provider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsLDevCtxToLDev](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsLIfCtxToBD_consumer](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsLIfCtxToBD_provider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsLIfCtxToCustQosPol_consumer](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsLIfCtxToCustQosPol_provider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsLIfCtxToInstP_consumer](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsLIfCtxToInstP_provider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsLIfCtxToLIf_consumer](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsLIfCtxToLIf_provider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsLIfCtxToSvcEPgPol_consumer](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsLIfCtxToSvcEPgPol_provider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsLIfCtxToSvcRedirectPol_consumer](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsLIfCtxToSvcRedirectPol_provider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->