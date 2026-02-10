<!-- BEGIN_TF_DOCS -->
# Terraform ACI Bridge Domain Module

Manages ACI Bridge Domain

Location in GUI:
`Tenants` » `XXX` » `Networking` » `Bridge Domains`

## Examples

```hcl
module "aci_bridge_domain" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bridge-domain"
  version = ">= 0.8.0"

  tenant                     = "ABC"
  name                       = "BD1"
  alias                      = "BD1-ALIAS"
  description                = "My Description"
  arp_flooding               = true
  advertise_host_routes      = true
  ip_dataplane_learning      = false
  limit_ip_learn_to_subnets  = false
  mac                        = "11:11:11:11:11:11"
  ep_move_detection          = true
  virtual_mac                = "22:22:22:22:22:22"
  l3_multicast               = true
  multicast_arp_drop         = true
  multi_destination_flooding = "drop"
  unicast_routing            = false
  unknown_unicast            = "flood"
  unknown_ipv4_multicast     = "opt-flood"
  unknown_ipv6_multicast     = "opt-flood"
  vrf                        = "VRF1"
  nd_interface_policy        = "ND_INTF_POL1"
  endpoint_retention_policy  = "ERP1"
  legacy_mode_vlan           = 135
  subnets = [{
    description        = "Subnet Description"
    ip                 = "1.1.1.1/24"
    primary_ip         = true
    public             = true
    shared             = true
    igmp_querier       = true
    nd_ra_prefix       = false
    no_default_gateway = false
    tags = [
      {
        key   = "tag_key"
        value = "tag_value"
      }
    ]
  }]
  l3outs = ["L3OUT1"]
  dhcp_labels = [{
    dhcp_relay_policy  = "DHCP_RELAY_1"
    dhcp_option_policy = "DHCP_OPTION_1"
  }]
  netflow_monitor_policies = [{
    name           = "NETFLOW_MONITOR_1"
    ip_filter_type = "ipv4"
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
| <a name="input_name"></a> [name](#input\_name) | Bridge domain name. | `string` | n/a | yes |
| <a name="input_annotation"></a> [annotation](#input\_annotation) | Annotation value. | `string` | `null` | no |
| <a name="input_alias"></a> [alias](#input\_alias) | Alias. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_arp_flooding"></a> [arp\_flooding](#input\_arp\_flooding) | ARP flooding. | `bool` | `false` | no |
| <a name="input_advertise_host_routes"></a> [advertise\_host\_routes](#input\_advertise\_host\_routes) | Advertisement of host routes. | `bool` | `false` | no |
| <a name="input_ip_dataplane_learning"></a> [ip\_dataplane\_learning](#input\_ip\_dataplane\_learning) | IP data plane learning. | `bool` | `true` | no |
| <a name="input_limit_ip_learn_to_subnets"></a> [limit\_ip\_learn\_to\_subnets](#input\_limit\_ip\_learn\_to\_subnets) | Limit IP learning to subnets. | `bool` | `true` | no |
| <a name="input_mac"></a> [mac](#input\_mac) | MAC address. Format: `12:34:56:78:9A:BC`. | `string` | `"00:22:BD:F8:19:FF"` | no |
| <a name="input_ep_move_detection"></a> [ep\_move\_detection](#input\_ep\_move\_detection) | Endpoint move detection flag. | `bool` | `false` | no |
| <a name="input_clear_remote_mac_entries"></a> [clear\_remote\_mac\_entries](#input\_clear\_remote\_mac\_entries) | Clear remote MAC entries flag. | `bool` | `false` | no |
| <a name="input_multicast_arp_drop"></a> [multicast\_arp\_drop](#input\_multicast\_arp\_drop) | Drop ARP with Multicast SMAC. | `bool` | `null` | no |
| <a name="input_virtual_mac"></a> [virtual\_mac](#input\_virtual\_mac) | Virtual MAC address. Format: `12:34:56:78:9A:BC`. | `string` | `"not-applicable"` | no |
| <a name="input_l3_multicast"></a> [l3\_multicast](#input\_l3\_multicast) | L3 multicast. | `bool` | `false` | no |
| <a name="input_pim_source_filter"></a> [pim\_source\_filter](#input\_pim\_source\_filter) | PIM source filter. | `string` | `""` | no |
| <a name="input_pim_destination_filter"></a> [pim\_destination\_filter](#input\_pim\_destination\_filter) | PIM destination filter. | `string` | `""` | no |
| <a name="input_multi_destination_flooding"></a> [multi\_destination\_flooding](#input\_multi\_destination\_flooding) | Multi destination flooding. Choices: `bd-flood`, `encap-flood`, `drop`. | `string` | `"bd-flood"` | no |
| <a name="input_unicast_routing"></a> [unicast\_routing](#input\_unicast\_routing) | Unicast routing. | `bool` | `true` | no |
| <a name="input_unknown_unicast"></a> [unknown\_unicast](#input\_unknown\_unicast) | Unknown unicast forwarding behavior. Choices: `flood`, `proxy`. | `string` | `"proxy"` | no |
| <a name="input_unknown_ipv4_multicast"></a> [unknown\_ipv4\_multicast](#input\_unknown\_ipv4\_multicast) | Unknown IPv4 multicast forwarding behavior. Choices: `flood`, `opt-flood`. | `string` | `"flood"` | no |
| <a name="input_unknown_ipv6_multicast"></a> [unknown\_ipv6\_multicast](#input\_unknown\_ipv6\_multicast) | Unknown IPV6 multicast forwarding behavior. Choices: `flood`, `opt-flood`. | `string` | `"flood"` | no |
| <a name="input_vrf"></a> [vrf](#input\_vrf) | VRF name. | `string` | n/a | yes |
| <a name="input_igmp_interface_policy"></a> [igmp\_interface\_policy](#input\_igmp\_interface\_policy) | IGMP interface policy. | `string` | `""` | no |
| <a name="input_igmp_snooping_policy"></a> [igmp\_snooping\_policy](#input\_igmp\_snooping\_policy) | IGMP snooping policy. | `string` | `""` | no |
| <a name="input_nd_interface_policy"></a> [nd\_interface\_policy](#input\_nd\_interface\_policy) | ND interface policy. | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets. Default value `primary_ip`: `false`. Default value `public`: `false`. Default value `shared`: `false`. Default value `igmp_querier`: `false`. Default value `nd_ra_prefix`: `true`. Default value `no_default_gateway`: `false`. Default value `virtual`: `false`. | <pre>list(object({<br/>    description           = optional(string, "")<br/>    ip                    = string<br/>    primary_ip            = optional(bool, false)<br/>    public                = optional(bool, false)<br/>    shared                = optional(bool, false)<br/>    igmp_querier          = optional(bool, false)<br/>    nd_ra_prefix          = optional(bool, true)<br/>    no_default_gateway    = optional(bool, false)<br/>    virtual               = optional(bool, false)<br/>    nd_ra_prefix_policy   = optional(string, "")<br/>    ip_dataplane_learning = optional(bool, null)<br/>    tags = optional(list(object({<br/>      key   = string<br/>      value = string<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_l3outs"></a> [l3outs](#input\_l3outs) | List of l3outs | `list(string)` | `[]` | no |
| <a name="input_dhcp_labels"></a> [dhcp\_labels](#input\_dhcp\_labels) | List of DHCP labels | <pre>list(object({<br/>    dhcp_relay_policy  = string<br/>    dhcp_option_policy = optional(string)<br/>    scope              = optional(string, "tenant")<br/>  }))</pre> | `[]` | no |
| <a name="input_endpoint_retention_policy"></a> [endpoint\_retention\_policy](#input\_endpoint\_retention\_policy) | Endpoint Retention Policy. | `string` | `""` | no |
| <a name="input_netflow_monitor_policies"></a> [netflow\_monitor\_policies](#input\_netflow\_monitor\_policies) | List of Netflow Monitor policies | <pre>list(object({<br/>    name           = string<br/>    ip_filter_type = optional(string, "ipv4")<br/>  }))</pre> | `[]` | no |
| <a name="input_legacy_mode_vlan"></a> [legacy\_mode\_vlan](#input\_legacy\_mode\_vlan) | Legacy Mode VLAN. Allowed values `vlan`: `1` - `4094`. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fvBD` object. |
| <a name="output_name"></a> [name](#output\_name) | Bridge domain name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.dhcpLbl](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dhcpRsDhcpOptionPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvAccP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvBD](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsBDToNdP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsBDToNetflowMonitorPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsBDToOut](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsBdToEpRet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsCtx](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsIgmpsn](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsNdPfxPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvSubnet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.igmpIfP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.igmpRsIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimBDDestFilterPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimBDFilterPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimBDP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimBDSrcFilterPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_destination](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtdmcRsFilterToRtMapPol_source](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.tagTag](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->