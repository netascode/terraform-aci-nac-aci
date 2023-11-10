<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-l3out-node-profile/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-l3out-node-profile/actions/workflows/test.yml)

# Terraform ACI L3out Node Profile Module

Description

Location in GUI:
`Tenants` » `XXX` » `Networking` » `L3outs` » `XXX` » `Logical Node Profiles`

## Examples

```hcl
module "aci_l3out_node_profile" {
  source  = "netascode/l3out-node-profile/aci"
  version = ">= 0.2.1"

  tenant      = "ABC"
  l3out       = "L3OUT1"
  name        = "NP1"
  multipod    = true
  remote_leaf = false
  nodes = [{
    node_id               = 201
    pod_id                = 2
    router_id             = "2.2.2.2"
    router_id_as_loopback = false
    loopback              = "12.12.12.12"
    static_routes = [{
      prefix      = "0.0.0.0/0"
      description = "Default Route"
      preference  = 10
      bfd         = true
      next_hops = [{
        ip         = "3.3.3.3"
        preference = 10
        type       = "prefix"
      }]
    }]
  }]
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
| <a name="input_l3out"></a> [l3out](#input\_l3out) | L3out name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Node profile name. | `string` | n/a | yes |
| <a name="input_nodes"></a> [nodes](#input\_nodes) | List of nodes. Allowed values `node_id`: 1-4000. Allowed values `pod_id`: 1-255. Default value `pod_id`: 1. Default value `router_id_as_loopback`: true. Allowed values `static_routes.preference`: 1-255. Default value `static_routes.preference`: 1. Default value `static_routes.bfd`: false. Allowed values `static_routes.next_hops.preference`: 0-255. Default value `static_routes.next_hops.preference`: 1. Choices `type`: `prefix`, `none`. Default value `type`: `prefix`. | <pre>list(object({<br>    node_id                 = number<br>    pod_id                  = optional(number, 1)<br>    router_id               = string<br>    router_id_as_loopback   = optional(bool, true)<br>    loopback                = optional(string)<br>    mpls_transport_loopback = optional(string)<br>    segment_id              = optional(number)<br>    static_routes = optional(list(object({<br>      prefix      = string<br>      description = optional(string, "")<br>      preference  = optional(number, 1)<br>      bfd         = optional(bool, false)<br>      next_hops = optional(list(object({<br>        ip         = string<br>        preference = optional(number, 1)<br>        type       = optional(string, "prefix")<br>      })), [])<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_bgp_peers"></a> [bgp\_peers](#input\_bgp\_peers) | List of BGP peers. Allowed values `remote_as`: 0-4294967295. Default value `allow_self_as`: false. Default value `as_override`: false. Default value `disable_peer_as_check`: false. Default value `next_hop_self`: false. Default value `send_community`: false. Default value `send_ext_community`: false. Allowed values `allowed_self_as_count`: 1-10. Default value `allowed_self_as_count`: 3. Default value `bfd`: false. Default value `disable_connected_check`: false. Allowed values `ttl`: 1-255. Default value `ttl`: 1. Allowed values `weight`: 0-65535. Default value `weight`: 0. Default value `remove_all_private_as`: false. Default value `remove_private_as`: false. Default value `replace_private_as_with_local_as`: false. Default value `unicast_address_family`: true. Default value `multicast_address_family`: true. Default value `admin_state`: true. Allowed values `local_as`: 0-4294967295. Choices `as_propagate`: `none`, `no-prepend`, `replace-as`, `dual-as`. Default value `as_propagate`: `none`. | <pre>list(object({<br>    ip                               = string<br>    remote_as                        = string<br>    description                      = optional(string, "")<br>    allow_self_as                    = optional(bool, false)<br>    as_override                      = optional(bool, false)<br>    disable_peer_as_check            = optional(bool, false)<br>    next_hop_self                    = optional(bool, false)<br>    send_community                   = optional(bool, false)<br>    send_ext_community               = optional(bool, false)<br>    password                         = optional(string)<br>    allowed_self_as_count            = optional(number, 3)<br>    bfd                              = optional(bool, false)<br>    disable_connected_check          = optional(bool, false)<br>    ttl                              = optional(number, 1)<br>    weight                           = optional(number, 0)<br>    remove_all_private_as            = optional(bool, false)<br>    remove_private_as                = optional(bool, false)<br>    replace_private_as_with_local_as = optional(bool, false)<br>    unicast_address_family           = optional(bool, true)<br>    multicast_address_family         = optional(bool, true)<br>    admin_state                      = optional(bool, true)<br>    local_as                         = optional(number)<br>    as_propagate                     = optional(string, "none")<br>    peer_prefix_policy               = optional(string)<br>    export_route_control             = optional(string)<br>    import_route_control             = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_multipod"></a> [multipod](#input\_multipod) | Multipod L3out flag. | `bool` | `false` | no |
| <a name="input_remote_leaf"></a> [remote\_leaf](#input\_remote\_leaf) | Remote leaf L3out flag. | `bool` | `false` | no |
| <a name="input_sr_mpls"></a> [sr\_mpls](#input\_sr\_mpls) | SR MPLS L3out flag. | `bool` | `false` | no |
| <a name="input_bgp_infra_peers"></a> [bgp\_infra\_peers](#input\_bgp\_infra\_peers) | List of BGP EVPN peers for SR MPLS L3out. Allowed values `remote_as`: 0-4294967295. Default value `allow_self_as`: false. Default value `disable_peer_as_check`: false. Default value `bfd`: false. Default value `ttl`: 2. Default value `admin_state`: true. Allowed values `local_as`: 0-4294967295. Choices `as_propagate`: `none`, `no-prepend`, `replace-as`, `dual-as`. Default value `as_propagate`: `none`. | <pre>list(object({<br>    ip                    = string<br>    remote_as             = string<br>    description           = optional(string, "")<br>    allow_self_as         = optional(bool, false)<br>    disable_peer_as_check = optional(bool, false)<br>    password              = optional(string)<br>    bfd                   = optional(bool, false)<br>    ttl                   = optional(number, 1)<br>    admin_state           = optional(bool, true)<br>    local_as              = optional(number)<br>    as_propagate          = optional(string, "none")<br>    peer_prefix_policy    = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_mpls_custom_qos_policy"></a> [mpls\_custom\_qos\_policy](#input\_mpls\_custom\_qos\_policy) | MPLS Customer QoS Policy | `string` | `""` | no |
| <a name="input_bfd_multihop_node_policy"></a> [bfd\_multihop\_node\_policy](#input\_bfd\_multihop\_node\_policy) | BFD Multihop Node Policy | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `l3extLNodeP` object. |
| <a name="output_name"></a> [name](#output\_name) | Node profile name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.bfdMhNodeP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bfdRsMhNodePol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpAsP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpAsP-bgpInfraPeerP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpInfraPeerP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpLocalAsnP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpLocalAsnP-bgpInfraPeerP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpPeerP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRsPeerPfxPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRsPeerPfxPol-bgpInfraPeerP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRsPeerToProfile_export](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgpRsPeerToProfile_import](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.ipNexthopP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.ipRouteP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extInfraNodeP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extLNodeP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extLoopBackIfP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsLNodePMplsCustQosPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.l3extRsNodeL3OutAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.mplsNodeSidP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->