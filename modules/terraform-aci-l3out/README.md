<!-- BEGIN_TF_DOCS -->
# Terraform ACI L3out Module

Manages ACI L3out

Location in GUI:
`Tenants` » `XXX` » `Networking` » `L3outs`

## Examples

```hcl
module "aci_l3out" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-l3out"
  version = ">= 0.8.0"

  tenant                                  = "ABC"
  name                                    = "L3OUT1"
  multipod                                = false
  alias                                   = "L3OUT1-ALIAS"
  description                             = "My Description"
  routed_domain                           = "RD1"
  vrf                                     = "VRF1"
  bgp                                     = true
  ospf                                    = true
  ospf_area                               = "0.0.0.10"
  ospf_area_cost                          = 10
  ospf_area_type                          = "stub"
  ospf_area_control_redistribute          = true
  ospf_area_control_summary               = true
  ospf_area_control_suppress_fa           = false
  l3_multicast_ipv4                       = true
  target_dscp                             = "CS0"
  import_route_control_enforcement        = true
  export_route_control_enforcement        = true
  interleak_route_map                     = "ILRM"
  dampening_ipv4_route_map                = "D4RM"
  dampening_ipv6_route_map                = "D6RM"
  default_route_leak_policy               = true
  default_route_leak_policy_always        = true
  default_route_leak_policy_criteria      = "in-addition"
  default_route_leak_policy_context_scope = false
  default_route_leak_policy_outside_scope = false
  redistribution_route_maps = [{
    source    = "direct"
    route_map = "RRM"
  }]
  import_route_map_description = "IRM Description"
  import_route_map_type        = "global"
  import_route_map_contexts = [{
    name        = "ICON1"
    description = "ICON1 Description"
    action      = "deny"
    order       = 5
    set_rule    = "ISET1"
    match_rule  = "IMATCH1"
  }]
  export_route_map_description = "ERM Description"
  export_route_map_type        = "global"
  export_route_map_contexts = [{
    name        = "ECON1"
    description = "ECON1 Description"
    action      = "deny"
    order       = 6
    set_rule    = "ESET1"
    match_rule  = "EMATCH1"
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.15.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | L3out name. | `string` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | Alias. | `string` | `""` | no |
| <a name="input_annotation"></a> [annotation](#input\_annotation) | Annotation value. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_routed_domain"></a> [routed\_domain](#input\_routed\_domain) | Routed domain name. | `string` | n/a | yes |
| <a name="input_vrf"></a> [vrf](#input\_vrf) | VRF name. | `string` | n/a | yes |
| <a name="input_ospf"></a> [ospf](#input\_ospf) | Enable OSPF routing. | `bool` | `false` | no |
| <a name="input_bgp"></a> [bgp](#input\_bgp) | Enable BGP routing. | `bool` | `false` | no |
| <a name="input_eigrp"></a> [eigrp](#input\_eigrp) | Enable EIGRP routing. | `bool` | `false` | no |
| <a name="input_ospf_area"></a> [ospf\_area](#input\_ospf\_area) | OSPF area. Allowed values are `backbone`, a number between 1 and 4294967295, or an ID in IP address format. | `string` | `"backbone"` | no |
| <a name="input_ospf_area_cost"></a> [ospf\_area\_cost](#input\_ospf\_area\_cost) | OSPF area cost. Minimum value: 1. Maximum value: 16777215. | `number` | `1` | no |
| <a name="input_ospf_area_type"></a> [ospf\_area\_type](#input\_ospf\_area\_type) | OSPF area type. Choices: `regular`, `stub`, `nssa`. | `string` | `"regular"` | no |
| <a name="input_ospf_area_control_redistribute"></a> [ospf\_area\_control\_redistribute](#input\_ospf\_area\_control\_redistribute) | Send redistributed LSAs into NSSA area. | `bool` | `true` | no |
| <a name="input_ospf_area_control_summary"></a> [ospf\_area\_control\_summary](#input\_ospf\_area\_control\_summary) | Originate summary LSA. | `bool` | `true` | no |
| <a name="input_ospf_area_control_suppress_fa"></a> [ospf\_area\_control\_suppress\_fa](#input\_ospf\_area\_control\_suppress\_fa) | Suppress forwarding address in translated LSA. | `bool` | `false` | no |
| <a name="input_eigrp_asn"></a> [eigrp\_asn](#input\_eigrp\_asn) | EIGRP Autonomous System Number area cost. Minimum value: 1. Maximum value: 65535. | `number` | `1` | no |
| <a name="input_l3_multicast_ipv4"></a> [l3\_multicast\_ipv4](#input\_l3\_multicast\_ipv4) | L3 IPv4 Multicast. | `bool` | `false` | no |
| <a name="input_target_dscp"></a> [target\_dscp](#input\_target\_dscp) | Target DSCP. Choices: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, `unspecified` or a number between `0` and `63`. | `string` | `"unspecified"` | no |
| <a name="input_import_route_control_enforcement"></a> [import\_route\_control\_enforcement](#input\_import\_route\_control\_enforcement) | L3 Import Route-Control Enforcement. | `bool` | `false` | no |
| <a name="input_export_route_control_enforcement"></a> [export\_route\_control\_enforcement](#input\_export\_route\_control\_enforcement) | L3 Export Route-Control Enforcement. | `bool` | `true` | no |
| <a name="input_interleak_route_map"></a> [interleak\_route\_map](#input\_interleak\_route\_map) | Interleak route map name. | `string` | `""` | no |
| <a name="input_dampening_ipv4_route_map"></a> [dampening\_ipv4\_route\_map](#input\_dampening\_ipv4\_route\_map) | Dampening IPv4 route map name. | `string` | `""` | no |
| <a name="input_dampening_ipv6_route_map"></a> [dampening\_ipv6\_route\_map](#input\_dampening\_ipv6\_route\_map) | Dampening IPv6 route map name. | `string` | `""` | no |
| <a name="input_default_route_leak_policy"></a> [default\_route\_leak\_policy](#input\_default\_route\_leak\_policy) | Default route leak policy. | `bool` | `false` | no |
| <a name="input_default_route_leak_policy_always"></a> [default\_route\_leak\_policy\_always](#input\_default\_route\_leak\_policy\_always) | Default route leak policy always. | `bool` | `false` | no |
| <a name="input_default_route_leak_policy_criteria"></a> [default\_route\_leak\_policy\_criteria](#input\_default\_route\_leak\_policy\_criteria) | Default route leak policy criteria. Choices: `only`, `in-addition`. | `string` | `"only"` | no |
| <a name="input_default_route_leak_policy_context_scope"></a> [default\_route\_leak\_policy\_context\_scope](#input\_default\_route\_leak\_policy\_context\_scope) | Default route leak policy context scope. | `bool` | `true` | no |
| <a name="input_default_route_leak_policy_outside_scope"></a> [default\_route\_leak\_policy\_outside\_scope](#input\_default\_route\_leak\_policy\_outside\_scope) | Default route leak policy outside scope. | `bool` | `true` | no |
| <a name="input_redistribution_route_maps"></a> [redistribution\_route\_maps](#input\_redistribution\_route\_maps) | List of redistribution route maps. Choices `source`: `direct`, `attached-host`, `static`. Default value `source`: `static`. | <pre>list(object({<br/>    source    = optional(string, "static")<br/>    route_map = string<br/>  }))</pre> | `[]` | no |
| <a name="input_import_route_map_name"></a> [import\_route\_map\_name](#input\_import\_route\_map\_name) | Import Route Map Name. Default value: `default-import` | `string` | `"default-import"` | no |
| <a name="input_import_route_map_description"></a> [import\_route\_map\_description](#input\_import\_route\_map\_description) | Import route map description. | `string` | `""` | no |
| <a name="input_import_route_map_type"></a> [import\_route\_map\_type](#input\_import\_route\_map\_type) | Import route map type. Choices: `combinable`, `global`. | `string` | `"combinable"` | no |
| <a name="input_import_route_map_contexts"></a> [import\_route\_map\_contexts](#input\_import\_route\_map\_contexts) | List of import route map contexts. Choices `action`: `permit`, `deny`. Default value `action`: `permit`. Allowed values `order`: 0-9. Default value `order`: 0. | <pre>list(object({<br/>    name        = string<br/>    description = optional(string, "")<br/>    action      = optional(string, "permit")<br/>    order       = optional(number, 0)<br/>    set_rule    = optional(string)<br/>    match_rules = optional(list(string), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_export_route_map_name"></a> [export\_route\_map\_name](#input\_export\_route\_map\_name) | Export Route Map Name. Default value: `default-export` | `string` | `"default-export"` | no |
| <a name="input_export_route_map_description"></a> [export\_route\_map\_description](#input\_export\_route\_map\_description) | Import route map description. | `string` | `""` | no |
| <a name="input_export_route_map_type"></a> [export\_route\_map\_type](#input\_export\_route\_map\_type) | Import route map type. Choices: `combinable`, `global`. | `string` | `"combinable"` | no |
| <a name="input_export_route_map_contexts"></a> [export\_route\_map\_contexts](#input\_export\_route\_map\_contexts) | List of export route map contexts. Choices `action`: `permit`, `deny`. Default value `action`: `permit`. Allowed values `order`: 0-9. Default value `order`: 0. | <pre>list(object({<br/>    name        = string<br/>    description = optional(string, "")<br/>    action      = optional(string, "permit")<br/>    order       = optional(number, 0)<br/>    set_rule    = optional(string)<br/>    match_rules = optional(list(string), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_route_maps"></a> [route\_maps](#input\_route\_maps) | List of route maps | <pre>list(object({<br/>    name        = string<br/>    description = optional(string, "")<br/>    type        = optional(string, "combinable")<br/>    contexts = list(object({<br/>      name        = string<br/>      description = optional(string, "")<br/>      action      = optional(string, "permit")<br/>      order       = optional(number, 0)<br/>      set_rule    = optional(string)<br/>      match_rules = optional(list(string), [])<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_multipod"></a> [multipod](#input\_multipod) | Multipod L3out flag. | `bool` | `true` | no |
| <a name="input_sr_mpls"></a> [sr\_mpls](#input\_sr\_mpls) | SR MPLS L3out flag. | `bool` | `false` | no |
| <a name="input_sr_mpls_infra_l3outs"></a> [sr\_mpls\_infra\_l3outs](#input\_sr\_mpls\_infra\_l3outs) | SR MPLS Infra L3Outs. | <pre>list(object({<br/>    name                     = string<br/>    outbound_route_map       = optional(string, "")<br/>    inbound_route_map        = optional(string, "")<br/>    external_endpoint_groups = optional(list(string), [])<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `l3extOut` object. |
| <a name="output_name"></a> [name](#output\_name) | L3out name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.bgpExtP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.eigrpExtP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extConsLbl](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extDefaultRouteLeakP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extInstP_sr_mpls](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extOut](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extProvLbl](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsDampeningPol_ipv4](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsDampeningPol_ipv6](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsEctx](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsInterleakPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsL3DomAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsLblToInstP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsLblToProfile_export](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsLblToProfile_import](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsRedistributePol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mplsExtP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mplsRsLabelPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.ospfExtP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimExtP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlCtxP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlCtxP_export](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlCtxP_import](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlProfile](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlProfile_export](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlProfile_import](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlRsCtxPToSubjP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlRsCtxPToSubjP_export](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlRsCtxPToSubjP_import](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlRsScopeToAttrP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlRsScopeToAttrP_export](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlRsScopeToAttrP_import](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlScope](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlScope_export](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlScope_import](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->