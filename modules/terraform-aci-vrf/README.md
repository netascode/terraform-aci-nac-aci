<!-- BEGIN_TF_DOCS -->
# Terraform ACI VRF Module

Manages ACI VRF

Location in GUI:
`Tenants` » `XXX` » `Networking` » `VRFs`

## Examples

```hcl
module "aci_vrf" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-vrf"
  version = ">= 0.9.2"

  tenant                                 = "ABC"
  name                                   = "VRF1"
  alias                                  = "VRF1-ALIAS"
  description                            = "My Description"
  enforcement_direction                  = "egress"
  enforcement_preference                 = "unenforced"
  data_plane_learning                    = false
  preferred_group                        = true
  transit_route_tag_policy               = "TRP1"
  endpoint_retention_policy              = "ERP1"
  bgp_timer_policy                       = "BGP1"
  bgp_ipv4_address_family_context_policy = "BGP_AF_IPV4"
  bgp_ipv6_address_family_context_policy = "BGP_AF_IPV6"
  bgp_ipv4_import_route_target           = ["route-target:as2-nn2:10:10", "route-target:as2-nn2:10:11"]
  bgp_ipv4_export_route_target           = ["route-target:as2-nn2:10:12", "route-target:as2-nn2:10:13"]
  bgp_ipv6_import_route_target           = ["route-target:as2-nn2:10:14", "route-target:as2-nn2:10:15"]
  bgp_ipv6_export_route_target           = ["route-target:as2-nn2:10:16", "route-target:as2-nn2:10:17"]
  dns_labels                             = ["DNS1"]
  contract_consumers                     = ["CON1"]
  contract_providers                     = ["CON1"]
  contract_imported_consumers            = ["I_CON1"]
  snmp_context_name                      = "SNMP-CTX"
  snmp_context_community_profiles = [
    {
      name        = "Community-Profile1"
      description = "Community Profile 1 Description"
    },
    {
      name = "Community-Profile2"
    }
  ]
  pim_enabled                    = true
  pim_mtu                        = 9200
  pim_fast_convergence           = true
  pim_strict_rfc                 = true
  pim_max_multicast_entries      = 1000
  pim_reserved_multicast_entries = "undefined"
  pim_static_rps = [
    {
      ip                  = "1.1.1.1"
      multicast_route_map = "TEST_RM"
    },
    {
      ip = "1.1.1.2"
    }
  ]
  pim_fabric_rps = [
    {
      ip                  = "2.2.2.1"
      multicast_route_map = "TEST_RM"
    },
    {
      ip = "2.2.2.2"
    }
  ]
  pim_bsr_listen_updates                   = true
  pim_bsr_forward_updates                  = true
  pim_bsr_filter_multicast_route_map       = "MCAST_RM1"
  pim_auto_rp_listen_updates               = true
  pim_auto_rp_forward_updates              = true
  pim_auto_rp_filter_multicast_route_map   = "MCAST_RM2"
  pim_asm_shared_range_multicast_route_map = "MCAST_RM3"
  pim_asm_sg_expiry                        = 1800
  pim_asm_sg_expiry_multicast_route_map    = "MCAST_RM4"
  pim_asm_traffic_registry_max_rate        = 10
  pim_asm_traffic_registry_source_ip       = "1.1.1.1"
  pim_ssm_group_range_multicast_route_map  = "MCAST_RM5"
  pim_inter_vrf_policies = [
    {
      tenant              = "TEN2"
      vrf                 = "VRF1"
      multicast_route_map = "MCAST_RM6"
    }
  ]
  pim_igmp_ssm_translate_policies = [
    {
      group_prefix   = "228.0.0.0/8"
      source_address = "3.3.3.3"
    },
    {
      group_prefix   = "229.0.0.0/8"
      source_address = "4.4.4.4"
    }
  ]
  # EPG/BD Subnets (leakInternalSubnet)
  leaked_internal_subnets = [{
    prefix = "10.1.0.0/16"
    public = true
    destinations = [{
      description = "Leak to VRF2"
      tenant      = "ABC"
      vrf         = "VRF2"
      public      = false
    }]
  }]
  # Internal Prefixes (leakInternalPrefix) - prefix-level scope requires APIC 6.1+
  leaked_internal_prefixes = [{
    prefix             = "10.0.0.0/8"
    public             = true
    from_prefix_length = 16
    to_prefix_length   = 24
    destinations = [{
      description = "Leak to VRF2"
      tenant      = "ABC"
      vrf         = "VRF2"
      public      = false
    }]
  }]
  leaked_external_prefixes = [{
    prefix             = "2.2.0.0/16"
    from_prefix_length = 24
    to_prefix_length   = 32
    destinations = [{
      description = "Leak to VRF2"
      tenant      = "ABC"
      vrf         = "VRF2"
    }]
  }]
  route_summarization_policies = [{
    name = "RSP1"
    nodes = [{
      id  = 105
      pod = 2
    }]
    subnets = [{
      prefix                         = "1.1.0.0/16"
      bgp_route_summarization_policy = "ABC"
    }]
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | VRF name. | `string` | n/a | yes |
| <a name="input_annotation"></a> [annotation](#input\_annotation) | Annotation value. | `string` | `null` | no |
| <a name="input_alias"></a> [alias](#input\_alias) | VRF alias. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | VRF description. | `string` | `""` | no |
| <a name="input_snmp_context_name"></a> [snmp\_context\_name](#input\_snmp\_context\_name) | VRF SNMP Context name. | `string` | `""` | no |
| <a name="input_snmp_context_community_profiles"></a> [snmp\_context\_community\_profiles](#input\_snmp\_context\_community\_profiles) | VRF SNMP Context Community Profiles. | <pre>list(object({<br/>    name        = string<br/>    description = optional(string, "")<br/>  }))</pre> | `[]` | no |
| <a name="input_enforcement_direction"></a> [enforcement\_direction](#input\_enforcement\_direction) | VRF enforcement direction. Choices: `ingress`, `egress`. | `string` | `null` | no |
| <a name="input_enforcement_preference"></a> [enforcement\_preference](#input\_enforcement\_preference) | VRF enforcement preference. Choices: `enforced`, `unenforced`. | `string` | `"enforced"` | no |
| <a name="input_data_plane_learning"></a> [data\_plane\_learning](#input\_data\_plane\_learning) | VRF data plane learning. | `bool` | `true` | no |
| <a name="input_preferred_group"></a> [preferred\_group](#input\_preferred\_group) | VRF preferred group member. | `bool` | `false` | no |
| <a name="input_transit_route_tag_policy"></a> [transit\_route\_tag\_policy](#input\_transit\_route\_tag\_policy) | VRF transit route tag policy name. | `string` | `""` | no |
| <a name="input_ospf_timer_policy"></a> [ospf\_timer\_policy](#input\_ospf\_timer\_policy) | OSPF timer policy name. | `string` | `""` | no |
| <a name="input_ospf_ipv4_address_family_context_policy"></a> [ospf\_ipv4\_address\_family\_context\_policy](#input\_ospf\_ipv4\_address\_family\_context\_policy) | OSPF IPv4 address family context policy name. | `string` | `""` | no |
| <a name="input_ospf_ipv6_address_family_context_policy"></a> [ospf\_ipv6\_address\_family\_context\_policy](#input\_ospf\_ipv6\_address\_family\_context\_policy) | OSPF IPv6 address family context policy name. | `string` | `""` | no |
| <a name="input_bgp_timer_policy"></a> [bgp\_timer\_policy](#input\_bgp\_timer\_policy) | VRF BGP timer policy name. | `string` | `""` | no |
| <a name="input_bgp_ipv4_address_family_context_policy"></a> [bgp\_ipv4\_address\_family\_context\_policy](#input\_bgp\_ipv4\_address\_family\_context\_policy) | VRF BGP IPv4 Address Family Context policy name. | `string` | `""` | no |
| <a name="input_bgp_ipv6_address_family_context_policy"></a> [bgp\_ipv6\_address\_family\_context\_policy](#input\_bgp\_ipv6\_address\_family\_context\_policy) | VRF BGP IPv6 Address Family Context policy name. | `string` | `""` | no |
| <a name="input_bgp_ipv4_import_route_target"></a> [bgp\_ipv4\_import\_route\_target](#input\_bgp\_ipv4\_import\_route\_target) | VRF BGP IPv4 import route target. | `list(string)` | `[]` | no |
| <a name="input_bgp_ipv4_export_route_target"></a> [bgp\_ipv4\_export\_route\_target](#input\_bgp\_ipv4\_export\_route\_target) | VRF BGP IPv4 export route target. | `list(string)` | `[]` | no |
| <a name="input_bgp_ipv6_import_route_target"></a> [bgp\_ipv6\_import\_route\_target](#input\_bgp\_ipv6\_import\_route\_target) | VRF BGP IPv6 import route target. | `list(string)` | `[]` | no |
| <a name="input_bgp_ipv6_export_route_target"></a> [bgp\_ipv6\_export\_route\_target](#input\_bgp\_ipv6\_export\_route\_target) | VRF BGP IPv6 export route target. | `list(string)` | `[]` | no |
| <a name="input_dns_labels"></a> [dns\_labels](#input\_dns\_labels) | List of VRF DNS labels. | `list(string)` | `[]` | no |
| <a name="input_contract_consumers"></a> [contract\_consumers](#input\_contract\_consumers) | List of contract consumers. | `list(string)` | `[]` | no |
| <a name="input_contract_providers"></a> [contract\_providers](#input\_contract\_providers) | List of contract providers. | `list(string)` | `[]` | no |
| <a name="input_contract_imported_consumers"></a> [contract\_imported\_consumers](#input\_contract\_imported\_consumers) | List of imported contract consumers. | `list(string)` | `[]` | no |
| <a name="input_pim_enabled"></a> [pim\_enabled](#input\_pim\_enabled) | Enable PIM. Default value: `false`. | `bool` | `false` | no |
| <a name="input_pim_mtu"></a> [pim\_mtu](#input\_pim\_mtu) | VRF PIM MTU. Allowed values `1`-`9300`. Default value `1500` | `number` | `1500` | no |
| <a name="input_pim_fast_convergence"></a> [pim\_fast\_convergence](#input\_pim\_fast\_convergence) | VRF PIM fast convergence. Default value: `false`. | `bool` | `false` | no |
| <a name="input_pim_strict_rfc"></a> [pim\_strict\_rfc](#input\_pim\_strict\_rfc) | VRF PIM Strict RFC compliant. Default value: `false`. | `bool` | `false` | no |
| <a name="input_pim_max_multicast_entries"></a> [pim\_max\_multicast\_entries](#input\_pim\_max\_multicast\_entries) | VRF PIM maximum number of multicast entries. Allowed valued between `1`-`4294967295` or `unlimited`. Default value `unlimited.` | `string` | `"unlimited"` | no |
| <a name="input_pim_reserved_multicast_entries"></a> [pim\_reserved\_multicast\_entries](#input\_pim\_reserved\_multicast\_entries) | VRF PIM maximum number of multicast entries. Allowed valued between `0`-`4294967295`. Default value `undefined` | `string` | `"undefined"` | no |
| <a name="input_pim_resource_policy_multicast_route_map"></a> [pim\_resource\_policy\_multicast\_route\_map](#input\_pim\_resource\_policy\_multicast\_route\_map) | VRF PIM resource policy multicast route map. | `string` | `""` | no |
| <a name="input_pim_static_rps"></a> [pim\_static\_rps](#input\_pim\_static\_rps) | VRF PIM static RPs. | <pre>list(object({<br/>    ip                  = string<br/>    multicast_route_map = optional(string, "")<br/>  }))</pre> | `[]` | no |
| <a name="input_pim_fabric_rps"></a> [pim\_fabric\_rps](#input\_pim\_fabric\_rps) | VRF PIM fabric RPs. | <pre>list(object({<br/>    ip                  = string<br/>    multicast_route_map = optional(string, "")<br/>  }))</pre> | `[]` | no |
| <a name="input_pim_bsr_forward_updates"></a> [pim\_bsr\_forward\_updates](#input\_pim\_bsr\_forward\_updates) | VRF PIM BSR forward updates flag. Default value: `false`. | `bool` | `false` | no |
| <a name="input_pim_bsr_listen_updates"></a> [pim\_bsr\_listen\_updates](#input\_pim\_bsr\_listen\_updates) | VRF PIM BSR listen updates flag. Default value: `false`. | `bool` | `false` | no |
| <a name="input_pim_bsr_filter_multicast_route_map"></a> [pim\_bsr\_filter\_multicast\_route\_map](#input\_pim\_bsr\_filter\_multicast\_route\_map) | VRF PIM BSR multicast route map. | `string` | `""` | no |
| <a name="input_pim_auto_rp_forward_updates"></a> [pim\_auto\_rp\_forward\_updates](#input\_pim\_auto\_rp\_forward\_updates) | VRF PIM auto RP forward updates flag. Default value: `false`. | `bool` | `false` | no |
| <a name="input_pim_auto_rp_listen_updates"></a> [pim\_auto\_rp\_listen\_updates](#input\_pim\_auto\_rp\_listen\_updates) | VRF PIM auto RP listen updates flag. Default value: `false`. | `bool` | `false` | no |
| <a name="input_pim_auto_rp_filter_multicast_route_map"></a> [pim\_auto\_rp\_filter\_multicast\_route\_map](#input\_pim\_auto\_rp\_filter\_multicast\_route\_map) | VRF PIM auto RP multicast route map. | `string` | `""` | no |
| <a name="input_pim_asm_shared_range_multicast_route_map"></a> [pim\_asm\_shared\_range\_multicast\_route\_map](#input\_pim\_asm\_shared\_range\_multicast\_route\_map) | VRF PIM ASM shared range multicast route map. | `string` | `""` | no |
| <a name="input_pim_asm_sg_expiry"></a> [pim\_asm\_sg\_expiry](#input\_pim\_asm\_sg\_expiry) | VRF PIM ASM SG expiry timeout. Allowed values 180-604801 or `default-timeout`. Default value `default-timeout` | `string` | `"default-timeout"` | no |
| <a name="input_pim_asm_sg_expiry_multicast_route_map"></a> [pim\_asm\_sg\_expiry\_multicast\_route\_map](#input\_pim\_asm\_sg\_expiry\_multicast\_route\_map) | VRF PIM SG expiry multicast route map. | `string` | `""` | no |
| <a name="input_pim_asm_traffic_registry_max_rate"></a> [pim\_asm\_traffic\_registry\_max\_rate](#input\_pim\_asm\_traffic\_registry\_max\_rate) | VRF PIM ASM traffic registry max rate. Allowed values bewtween `1`-`65535`. Default value `65535` | `number` | `65535` | no |
| <a name="input_pim_asm_traffic_registry_source_ip"></a> [pim\_asm\_traffic\_registry\_source\_ip](#input\_pim\_asm\_traffic\_registry\_source\_ip) | VRF PIM ASM traffic registry source IP. | `string` | `""` | no |
| <a name="input_pim_ssm_group_range_multicast_route_map"></a> [pim\_ssm\_group\_range\_multicast\_route\_map](#input\_pim\_ssm\_group\_range\_multicast\_route\_map) | VRF PIM SSM group range multicast route map. | `string` | `""` | no |
| <a name="input_pim_inter_vrf_policies"></a> [pim\_inter\_vrf\_policies](#input\_pim\_inter\_vrf\_policies) | VRF PIM inter-VRF policies. | <pre>list(object({<br/>    tenant              = string<br/>    vrf                 = string<br/>    multicast_route_map = optional(string, "")<br/>  }))</pre> | `[]` | no |
| <a name="input_pim_igmp_ssm_translate_policies"></a> [pim\_igmp\_ssm\_translate\_policies](#input\_pim\_igmp\_ssm\_translate\_policies) | VRF IGMP SSM tranlate policies. | <pre>list(object({<br/>    group_prefix   = string<br/>    source_address = string<br/>  }))</pre> | `[]` | no |
| <a name="input_leaked_internal_subnets"></a> [leaked\_internal\_subnets](#input\_leaked\_internal\_subnets) | List of leaked internal subnets (EPG/BD Subnets - leakInternalSubnet). Default value `public`: false. | <pre>list(object({<br/>    prefix = string<br/>    public = optional(bool, false)<br/>    destinations = optional(list(object({<br/>      description = optional(string, "")<br/>      tenant      = string<br/>      vrf         = string<br/>      public      = optional(bool)<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_leaked_internal_prefixes"></a> [leaked\_internal\_prefixes](#input\_leaked\_internal\_prefixes) | List of leaked internal prefixes (leakInternalPrefix). Prefix-level `public` (scope) requires APIC 6.1+. Default value `public`: false. | <pre>list(object({<br/>    prefix             = string<br/>    public             = optional(bool, false)<br/>    from_prefix_length = optional(number)<br/>    to_prefix_length   = optional(number)<br/>    destinations = optional(list(object({<br/>      description = optional(string, "")<br/>      tenant      = string<br/>      vrf         = string<br/>      public      = optional(bool)<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_leaked_external_prefixes"></a> [leaked\_external\_prefixes](#input\_leaked\_external\_prefixes) | List of leaked external prefixes. | <pre>list(object({<br/>    prefix             = string<br/>    from_prefix_length = optional(number)<br/>    to_prefix_length   = optional(number)<br/>    destinations = optional(list(object({<br/>      description = optional(string, "")<br/>      tenant      = string<br/>      vrf         = string<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_route_summarization_policies"></a> [route\_summarization\_policies](#input\_route\_summarization\_policies) | List of route summarization policies. | <pre>list(object({<br/>    name = string<br/>    nodes = optional(list(object({<br/>      id  = number<br/>      pod = optional(number, 1)<br/>    })), [])<br/>    subnets = optional(list(object({<br/>      prefix                         = string<br/>      bgp_route_summarization_policy = optional(string, null)<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_endpoint_retention_policy"></a> [endpoint\_retention\_policy](#input\_endpoint\_retention\_policy) | Endpoint Retention Policy. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fvCtx` object. |
| <a name="output_name"></a> [name](#output\_name) | VRF name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.bgpRtTargetP_ipv4](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRtTargetP_ipv6](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRtTarget_ipv4_export](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRtTarget_ipv4_import](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRtTarget_ipv6_export](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRtTarget_ipv6_import](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dnsLbl](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvCtx](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvCtxRtSummPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsBgpCtxPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsCtxToBgpCtxAfPol_ipv4](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsCtxToBgpCtxAfPol_ipv6](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsCtxToEpRet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsCtxToExtRouteTagPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsCtxToOspfCtxPol_ipv4](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsCtxToOspfCtxPol_ipv6](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsOspfCtxPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRtSummSubnet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.igmpCtxP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.igmpSSMXlateP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.leakExternalPrefix](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.leakInternalPrefix](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.leakInternalSubnet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.leakRoutes](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.leakTo_external](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.leakTo_internal_prefix](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.leakTo_internal_subnet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimASMPatPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimAutoRPPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimBSRFilterPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimBSRPPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimCtxP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimFabricRPPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimInterVRFEntryPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimInterVRFPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimMAFilterPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimRPGrpRangePol_fabric_rp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimRPGrpRangePol_static_rp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimRegTrPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimResPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimSGRangeExpPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimSSMPatPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimSSMRangePol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimSharedRangePol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimStaticRPEntryPol_fabric_rp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimStaticRPEntryPol_static_rp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimStaticRPPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_asm_sg_expiry](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_asm_shared](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_auto_rp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_bsr](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_fabric_rp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_pim_inter_vrf](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_ssm_range](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_static_rp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmpCommunityP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmpCtxP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzAny](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsAnyToCons](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsAnyToConsIf](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsAnyToProv](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->