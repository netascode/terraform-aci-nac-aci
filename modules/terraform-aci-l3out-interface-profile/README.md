<!-- BEGIN_TF_DOCS -->
# Terraform ACI L3out Interface Profile Module

Manages ACI L3out Interface Profile

Location in GUI:
`Tenants` » `XXX` » `Networking` » `L3outs` » `XXX` » `Logical Node Profiles` » `XXX` » `Logical Interface Profiles`

## Examples

```hcl
module "aci_l3out_interface_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-l3out-interface-profile"
  version = ">= 0.9.1"

  tenant                      = "ABC"
  l3out                       = "L3OUT1"
  node_profile                = "NP1"
  name                        = "IP1"
  description                 = "Int Profile Description"
  multipod                    = false
  remote_leaf                 = false
  bfd_policy                  = "BFD1"
  ospf_interface_profile_name = "OSPFP1"
  ospf_authentication_key     = "12345678"
  ospf_authentication_key_id  = 2
  ospf_authentication_type    = "md5"
  ospf_interface_policy       = "OSPF1"
  igmp_interface_policy       = "IIP"
  nd_interface_policy         = "NDIP-SUPPRESS_RA"
  qos_class                   = "level2"
  custom_qos_policy           = "CQP"
  dhcp_labels = [
    {
      dhcp_relay_policy  = "DHCP-RELAY1"
      dhcp_option_policy = "DHCP_OPTION1"
    }
  ]
  interfaces = [{
    description          = "Interface 1"
    type                 = "vpc"
    svi                  = true
    scope                = "local"
    vlan                 = 5
    mac                  = "12:34:56:78:90:AB"
    mtu                  = "1500"
    mode                 = "native"
    node_id              = 201
    node2_id             = 202
    pod_id               = 2
    channel              = "VPC1"
    ip_a                 = "1.1.1.2/24"
    ip_b                 = "1.1.1.3/24"
    ip_shared            = "1.1.1.1/24"
    ip_shared_dhcp_relay = true
    lladdr               = "fe80::ffff:ffff:ffff:ffff"
    bgp_peers = [{
      ip                               = "4.4.4.4"
      remote_as                        = 12345
      description                      = "BGP Peer Description"
      allow_self_as                    = true
      as_override                      = true
      disable_peer_as_check            = true
      next_hop_self                    = false
      send_community                   = true
      send_ext_community               = true
      password                         = "BgpPassword"
      allowed_self_as_count            = 5
      bfd                              = true
      disable_connected_check          = true
      ttl                              = 2
      weight                           = 200
      remove_all_private_as            = true
      remove_private_as                = true
      replace_private_as_with_local_as = true
      unicast_address_family           = false
      multicast_address_family         = false
      admin_state                      = false
      local_as                         = 12346
      as_propagate                     = "no-prepend"
      peer_prefix_policy               = "PPP"
      export_route_control             = "ERC"
      import_route_control             = "IRC"
    }]
    },
    {
      description  = "Interface 2"
      floating_svi = true
      node_id      = 201
      ip           = "1.1.2.1/24"
      svi          = true
      vlan         = 6
      paths = [{
        physical_domain = PD-DOM1
        floating_ip     = "1.1.2.1/24"
        vlan            = "vlan-5"
      }]
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
| <a name="input_l3out"></a> [l3out](#input\_l3out) | L3out name. | `string` | n/a | yes |
| <a name="input_node_profile"></a> [node\_profile](#input\_node\_profile) | Node profile name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Interface profile name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Interface profile description. | `string` | `""` | no |
| <a name="input_bfd_policy"></a> [bfd\_policy](#input\_bfd\_policy) | BFD policy name. | `string` | `""` | no |
| <a name="input_ospf_interface_profile_name"></a> [ospf\_interface\_profile\_name](#input\_ospf\_interface\_profile\_name) | OSPF interface profile name. | `string` | `""` | no |
| <a name="input_ospf_authentication_key"></a> [ospf\_authentication\_key](#input\_ospf\_authentication\_key) | OSPF authentication key. | `string` | `""` | no |
| <a name="input_ospf_authentication_key_id"></a> [ospf\_authentication\_key\_id](#input\_ospf\_authentication\_key\_id) | OSPF authentication key ID. | `number` | `1` | no |
| <a name="input_ospf_authentication_type"></a> [ospf\_authentication\_type](#input\_ospf\_authentication\_type) | OSPF authentication type. Choices: `none`, `simple`, `md5`. | `string` | `"none"` | no |
| <a name="input_ospf_interface_policy"></a> [ospf\_interface\_policy](#input\_ospf\_interface\_policy) | OSPF interface policy name. | `string` | `""` | no |
| <a name="input_eigrp_interface_profile_name"></a> [eigrp\_interface\_profile\_name](#input\_eigrp\_interface\_profile\_name) | EIGRP interface profile name. | `string` | `""` | no |
| <a name="input_eigrp_keychain_policy"></a> [eigrp\_keychain\_policy](#input\_eigrp\_keychain\_policy) | EIGRP keychain policy name. | `string` | `""` | no |
| <a name="input_eigrp_interface_policy"></a> [eigrp\_interface\_policy](#input\_eigrp\_interface\_policy) | EIGRP interface policy name. | `string` | `""` | no |
| <a name="input_pim_policy"></a> [pim\_policy](#input\_pim\_policy) | PIM policy name. | `string` | `""` | no |
| <a name="input_igmp_interface_policy"></a> [igmp\_interface\_policy](#input\_igmp\_interface\_policy) | IGMP interface policy name. | `string` | `""` | no |
| <a name="input_nd_interface_policy"></a> [nd\_interface\_policy](#input\_nd\_interface\_policy) | ND interface policy. | `string` | `""` | no |
| <a name="input_qos_class"></a> [qos\_class](#input\_qos\_class) | QoS class. Choices: `level1`, `level2`, `level3`, `level4`, `level5`, `level6`, `unspecified`. | `string` | `"unspecified"` | no |
| <a name="input_custom_qos_policy"></a> [custom\_qos\_policy](#input\_custom\_qos\_policy) | Custom QoS policy name. | `string` | `""` | no |
| <a name="input_interfaces"></a> [interfaces](#input\_interfaces) | List of interfaces. Default value `svi`: false. Default value `floating_svi`: false. Choices `type`. `access`, `pc`, `vpc`. Default value `type`: `access`. Allowed values `vlan`: 1-4096. Format `mac`: `12:34:56:78:9A:BC`. `mtu`: Allowed values are `inherit` or a number between 576 and 9216. Allowed values `node_id`, `node2_id`: 1-4000. Allowed values `pod_id`: 1-255. Default value `pod_id`: 1. Allowed values `module`: 1-9. Default value `module`: 1. Allowed values `port`: 1-127. Default value `bgp_peers.bfd`: false. Allowed values `bgp_peers.ttl`: 1-255. Default value `bgp_peers.ttl`: 1. Allowed values `bgp_peers.weight`: 0-65535. Default value `bgp_peers.weight`: 0. Allowed values `bgp_peers.remote_as`: 0-4294967295. | <pre>list(object({<br/>    description          = optional(string, "")<br/>    type                 = optional(string, "access")<br/>    node_id              = number<br/>    node2_id             = optional(number)<br/>    pod_id               = optional(number, 1)<br/>    module               = optional(number, 1)<br/>    port                 = optional(number)<br/>    sub_port             = optional(number)<br/>    channel              = optional(string)<br/>    ip                   = optional(string)<br/>    svi                  = optional(bool, false)<br/>    autostate            = optional(bool, false)<br/>    floating_svi         = optional(bool, false)<br/>    vlan                 = optional(number)<br/>    mac                  = optional(string, "00:22:BD:F8:19:FF")<br/>    mtu                  = optional(string, "inherit")<br/>    mode                 = optional(string, "regular")<br/>    ip_a                 = optional(string)<br/>    ip_b                 = optional(string)<br/>    ip_shared            = optional(string)<br/>    ip_shared_dhcp_relay = optional(bool, null)<br/>    lladdr               = optional(string, "::")<br/>    scope                = optional(string, "local")<br/>    multipod_direct      = optional(bool, false)<br/>    bgp_peers = optional(list(object({<br/>      ip                               = string<br/>      remote_as                        = string<br/>      description                      = optional(string, "")<br/>      allow_self_as                    = optional(bool, false)<br/>      as_override                      = optional(bool, false)<br/>      disable_peer_as_check            = optional(bool, false)<br/>      next_hop_self                    = optional(bool, false)<br/>      send_community                   = optional(bool, false)<br/>      send_ext_community               = optional(bool, false)<br/>      password                         = optional(string)<br/>      allowed_self_as_count            = optional(number, 3)<br/>      bfd                              = optional(bool, false)<br/>      disable_connected_check          = optional(bool, false)<br/>      ttl                              = optional(number, 1)<br/>      weight                           = optional(number, 0)<br/>      remove_all_private_as            = optional(bool, false)<br/>      remove_private_as                = optional(bool, false)<br/>      replace_private_as_with_local_as = optional(bool, false)<br/>      unicast_address_family           = optional(bool, true)<br/>      multicast_address_family         = optional(bool, true)<br/>      admin_state                      = optional(bool, true)<br/>      local_as                         = optional(number)<br/>      as_propagate                     = optional(string, "none")<br/>      peer_prefix_policy               = optional(string)<br/>      export_route_control             = optional(string)<br/>      import_route_control             = optional(string)<br/>    })), [])<br/>    paths = optional(list(object({<br/>      physical_domain   = optional(string)<br/>      vmware_vmm_domain = optional(string)<br/>      elag              = optional(string)<br/>      floating_ip       = string<br/>      vlan              = optional(string)<br/>    })), [])<br/>    micro_bfd_destination_ip = optional(string, "")<br/>    micro_bfd_start_timer    = optional(number, 0)<br/>  }))</pre> | `[]` | no |
| <a name="input_multipod"></a> [multipod](#input\_multipod) | Multipod L3out flag. | `bool` | `false` | no |
| <a name="input_remote_leaf"></a> [remote\_leaf](#input\_remote\_leaf) | Remote leaf L3out flag. | `bool` | `false` | no |
| <a name="input_sr_mpls"></a> [sr\_mpls](#input\_sr\_mpls) | SR MPLS L3out flag. | `bool` | `false` | no |
| <a name="input_transport_data_plane"></a> [transport\_data\_plane](#input\_transport\_data\_plane) | Transport Data Plane. Allowed values: `sr_mpls`, `mpls`. Default value: `sr_mpls`. | `string` | `"sr_mpls"` | no |
| <a name="input_dhcp_labels"></a> [dhcp\_labels](#input\_dhcp\_labels) | List of DHCP labels | <pre>list(object({<br/>    dhcp_relay_policy  = string<br/>    dhcp_option_policy = optional(string)<br/>    scope              = optional(string, "infra")<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `l3extLIfP` object. |
| <a name="output_name"></a> [name](#output\_name) | Interface profile name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.bfdIfP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bfdMicroBfdP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bfdRsIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpAsP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpAsP_floating](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpLocalAsnP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpLocalAsnP_floating](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpPeerP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpPeerP_floating](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRsPeerPfxPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRsPeerPfxPol_floating](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRsPeerToProfile_export](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRsPeerToProfile_export_floating](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRsPeerToProfile_import](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRsPeerToProfile_import_floating](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dhcpLbl](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dhcpRelayGwExtIp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dhcpRelayGwExtIp_A](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dhcpRelayGwExtIp_B](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dhcpRsDhcpOptionPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.eigrpAuthIfP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.eigrpIfP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.eigrpRsIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.eigrpRsKeyChainPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.igmpIfP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.igmpRsIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extIp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extIp_A](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extIp_B](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extIp_float](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extLIfP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extMember_A](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extMember_B](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsDynPathAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsLIfPCustQosPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsNdIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsPathL3OutAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsVSwitchEnhancedLagPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extVirtualLIfP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extVirtualLIfPLagPolAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mplsIfP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mplsRsIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.ospfIfP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.ospfRsIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimIfP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pimRsIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->