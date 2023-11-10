<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-endpoint-group/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-endpoint-group/actions/workflows/test.yml)

# Terraform ACI Endpoint Group Module

Manages ACI Endpoint Group

Location in GUI:
`Tenants` » `XXX` » `Application Profiles` » `XXX` » `Application EPGs`

## Examples

```hcl
module "aci_endpoint_group" {
  source  = "netascode/endpoint-group/aci"
  version = ">= 0.2.11"

  tenant                      = "ABC"
  application_profile         = "AP1"
  name                        = "EPG1"
  alias                       = "EPG1-ALIAS"
  description                 = "My Description"
  flood_in_encap              = false
  intra_epg_isolation         = true
  preferred_group             = true
  qos_class                   = "level1"
  custom_qos_policy           = "CQP1"
  bridge_domain               = "BD1"
  trust_control_policy        = "TRUST_POL"
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["I_CON1"]
  contract_intra_epgs         = ["CON1"]
  contract_masters = [{
    endpoint_group      = "EPG2"
    application_profile = "AP1"
  }]
  physical_domains = ["PHY1"]
  tags = [
    "tag1",
    "tag2"
  ]
  subnets = [{
    description        = "Subnet Description"
    ip                 = "1.1.1.1/24"
    public             = true
    shared             = true
    igmp_querier       = true
    nd_ra_prefix       = true
    no_default_gateway = false
  }]
  vmware_vmm_domains = [{
    name                 = "VMW1"
    u_segmentation       = true
    delimiter            = ":"
    vlan                 = 123
    netflow              = false
    deployment_immediacy = "lazy"
    resolution_immediacy = "lazy"
    allow_promiscuous    = true
    forged_transmits     = true
    mac_changes          = true
    custom_epg_name      = "custom-epg-name"
  }]
  static_ports = [{
    node_id              = 101
    vlan                 = 123
    pod_id               = 1
    port                 = 10
    sub_port             = 1
    module               = 1
    deployment_immediacy = "lazy"
    mode                 = "untagged"
  }]
  static_leafs = [{
    node_id              = 102
    vlan                 = 124
    deployment_immediacy = "lazy"
    mode                 = "untagged"
  }]
  static_endpoints = [{
    name           = "EP1"
    alias          = "EP1-ALIAS"
    mac            = "11:11:11:11:11:11"
    ip             = "1.1.1.10"
    type           = "silent-host"
    node_id        = 101
    node2_id       = 102
    vlan           = 123
    pod_id         = 1
    channel        = "VPC1"
    additional_ips = ["1.1.1.11"]
  }]
  l4l7_virtual_ips = [{
    ip          = "1.2.3.4"
    description = "My Virtual IP"
  }]
  l4l7_address_pools = [{
    name            = "POOL1"
    gateway_address = "1.1.1.1/24"
    from            = "1.1.1.10"
    to              = "1.1.1.100"
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
| <a name="input_application_profile"></a> [application\_profile](#input\_application\_profile) | Application profile name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Endpoint group name. | `string` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | Alias. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_flood_in_encap"></a> [flood\_in\_encap](#input\_flood\_in\_encap) | Flood in encapsulation. | `bool` | `false` | no |
| <a name="input_intra_epg_isolation"></a> [intra\_epg\_isolation](#input\_intra\_epg\_isolation) | Intra EPG isolation. | `bool` | `false` | no |
| <a name="input_proxy_arp"></a> [proxy\_arp](#input\_proxy\_arp) | Proxy-ARP | `bool` | `false` | no |
| <a name="input_preferred_group"></a> [preferred\_group](#input\_preferred\_group) | Preferred group membership. | `bool` | `false` | no |
| <a name="input_qos_class"></a> [qos\_class](#input\_qos\_class) | QoS class. | `string` | `"unspecified"` | no |
| <a name="input_custom_qos_policy"></a> [custom\_qos\_policy](#input\_custom\_qos\_policy) | Custom QoS policy name. | `string` | `""` | no |
| <a name="input_bridge_domain"></a> [bridge\_domain](#input\_bridge\_domain) | Bridge domain name. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of EPG tags. | `list(string)` | `[]` | no |
| <a name="input_trust_control_policy"></a> [trust\_control\_policy](#input\_trust\_control\_policy) | EPG Trust Control Policy Name. | `string` | `""` | no |
| <a name="input_contract_consumers"></a> [contract\_consumers](#input\_contract\_consumers) | List of contract consumers. | `list(string)` | `[]` | no |
| <a name="input_contract_providers"></a> [contract\_providers](#input\_contract\_providers) | List of contract providers. | `list(string)` | `[]` | no |
| <a name="input_contract_imported_consumers"></a> [contract\_imported\_consumers](#input\_contract\_imported\_consumers) | List of imported contract consumers. | `list(string)` | `[]` | no |
| <a name="input_contract_intra_epgs"></a> [contract\_intra\_epgs](#input\_contract\_intra\_epgs) | List of intra-EPG contracts. | `list(string)` | `[]` | no |
| <a name="input_contract_masters"></a> [contract\_masters](#input\_contract\_masters) | List of EPG contract masters. | <pre>list(object({<br>    endpoint_group      = string<br>    application_profile = optional(string, "")<br>  }))</pre> | `[]` | no |
| <a name="input_physical_domains"></a> [physical\_domains](#input\_physical\_domains) | List of physical domains. | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets. Default value `public`: `false`. Default value `shared`: `false`. Default value `igmp_querier`: `false`. Default value `nd_ra_prefix`: `true`. Default value `no_default_gateway`: `false`. `nlb_mode` allowed values: `mode-mcast-igmp`, `mode-uc` or `mode-mcast-static`. | <pre>list(object({<br>    description        = optional(string, "")<br>    ip                 = string<br>    public             = optional(bool, false)<br>    shared             = optional(bool, false)<br>    igmp_querier       = optional(bool, false)<br>    nd_ra_prefix       = optional(bool, true)<br>    no_default_gateway = optional(bool, false)<br>    ip_pools = optional(list(object({<br>      name              = string<br>      start_ip          = optional(string, "")<br>      end_ip            = optional(string, "")<br>      dns_search_suffix = optional(string, "")<br>      dns_server        = optional(string, "")<br>      dns_suffix        = optional(string, "")<br>      wins_server       = optional(string, "")<br>    })), [])<br>    next_hop_ip = optional(string, "")<br>    anycast_mac = optional(string, "")<br>    nlb_group   = optional(string, "0.0.0.0")<br>    nlb_mac     = optional(string, "00:00:00:00:00:00")<br>    nlb_mode    = optional(string, "")<br>  }))</pre> | `[]` | no |
| <a name="input_vmware_vmm_domains"></a> [vmware\_vmm\_domains](#input\_vmware\_vmm\_domains) | List of VMware VMM domains. Default value `u_segmentation`: `false`. Default value `netflow`: `false`. Choices `deployment_immediacy`: `immediate`, `lazy`. Default value `deployment_immediacy`: `lazy`. Choices `resolution_immediacy`: `immediate`, `lazy`, `pre-provision`. Default value `resolution_immediacy`: `immediate`. Default value `allow_promiscuous`: `false`. Default value `forged_transmits`: `false`. Default value `mac_changes`: `false`. | <pre>list(object({<br>    name                 = string<br>    u_segmentation       = optional(bool, false)<br>    delimiter            = optional(string, "")<br>    vlan                 = optional(number)<br>    primary_vlan         = optional(number)<br>    secondary_vlan       = optional(number)<br>    netflow              = optional(bool, false)<br>    deployment_immediacy = optional(string, "lazy")<br>    resolution_immediacy = optional(string, "immediate")<br>    allow_promiscuous    = optional(bool, false)<br>    forged_transmits     = optional(bool, false)<br>    mac_changes          = optional(bool, false)<br>    custom_epg_name      = optional(string, "")<br>    elag                 = optional(string, "")<br>    active_uplinks_order = optional(string, "")<br>    standby_uplinks      = optional(string, "")<br>  }))</pre> | `[]` | no |
| <a name="input_static_leafs"></a> [static\_leafs](#input\_static\_leafs) | List of static leaf switches. Allowed values `pod_id`: `1` - `255`. Default value `pod_id`: `1`. Allowed values `node_id`: `1` - `4000`. Allowed values `vlan`: `1` - `4096`. Choices `mode`: `regular`, `native`, `untagged`. Default value `mode`: `regular`. Choices `deployment_immediacy`: `immediate`, `lazy`. Default value `deployment_immediacy`: `immediate` | <pre>list(object({<br>    pod_id               = optional(number, 1)<br>    node_id              = number<br>    vlan                 = number<br>    mode                 = optional(string, "regular")<br>    deployment_immediacy = optional(string, "immediate")<br>  }))</pre> | `[]` | no |
| <a name="input_static_ports"></a> [static\_ports](#input\_static\_ports) | List of static ports. Allowed values `node_id`, `node2_id`: `1` - `4000`. Allowed values `fex_id`, `fex2_id`: `101` - `199`. Allowed values `vlan`: `1` - `4096`. Allowed values `pod_id`: `1` - `255`. Default value `pod_id`: `1`. Allowed values `port`: `1` - `127`. Allowed values `sub_port`: `1` - `16`. Allowed values `module`: `1` - `9`. Default value `module`: `1`. Choices `deployment_immediacy`: `immediate`, `lazy`. Default value `deployment_immediacy`: `lazy`. Choices `mode`: `regular`, `native`, `untagged`. Default value `mode`: `regular`. | <pre>list(object({<br>    node_id              = number<br>    node2_id             = optional(number)<br>    fex_id               = optional(number)<br>    fex2_id              = optional(number)<br>    vlan                 = number<br>    pod_id               = optional(number, 1)<br>    port                 = optional(number)<br>    sub_port             = optional(number)<br>    module               = optional(number, 1)<br>    channel              = optional(string)<br>    deployment_immediacy = optional(string, "lazy")<br>    mode                 = optional(string, "regular")<br>  }))</pre> | `[]` | no |
| <a name="input_static_endpoints"></a> [static\_endpoints](#input\_static\_endpoints) | List of static endpoints. Format `mac`: `12:34:56:78:9A:BC`. Choices `type`: `silent-host`, `tep`, `vep`. Allowed values `node_id`, `node2_id`: `1` - `4000`. Allowed values `vlan`: `1` - `4096`. Allowed values `pod_id`: `1` - `255`. Default value `pod_id`: `1`. Allowed values `port`: `1` - `127`. Allowed values `module`: `1` - `9`. Default value `module`: `1`. | <pre>list(object({<br>    name           = optional(string, "")<br>    alias          = optional(string, "")<br>    mac            = string<br>    ip             = optional(string, "0.0.0.0")<br>    type           = string<br>    node_id        = optional(number)<br>    node2_id       = optional(number)<br>    vlan           = optional(number)<br>    pod_id         = optional(number, 1)<br>    port           = optional(number)<br>    module         = optional(number, 1)<br>    channel        = optional(string)<br>    additional_ips = optional(list(string), [])<br>  }))</pre> | `[]` | no |
| <a name="input_l4l7_virtual_ips"></a> [l4l7\_virtual\_ips](#input\_l4l7\_virtual\_ips) | List of EPG L4/L7 Virtual IPs. | <pre>list(object({<br>    ip          = string<br>    description = optional(string, "")<br>  }))</pre> | `[]` | no |
| <a name="input_l4l7_address_pools"></a> [l4l7\_address\_pools](#input\_l4l7\_address\_pools) | List of EPG L4/L7 Address Pools. | <pre>list(object({<br>    name            = string<br>    gateway_address = string<br>    from            = optional(string, "")<br>    to              = optional(string, "")<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fvAEPg` object. |
| <a name="output_name"></a> [name](#output\_name) | Endpoint group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fvAEPg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvAEPgLagPolAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvCepNetCfgPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvEpAnycast](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvEpNlb](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvEpReachability](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsBd](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsCons](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsConsIf](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsCustQosPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsDomAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsDomAtt_vmm](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsIntraEpg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsNodeAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsPathAtt_channel](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsPathAtt_fex_channel](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsPathAtt_fex_port](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsPathAtt_port](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsPathAtt_subport](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsProv](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsSecInherited](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsStCEpToPathEp_channel](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsStCEpToPathEp_port](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsTrustCtrl](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvRsVmmVSwitchEnhancedLagPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvStCEp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvStIp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvSubnet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvUplinkOrderCont](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvVip](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvnsUcastAddrBlk](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.ipNexthopEpP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.tagInst](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmSecP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsAddrInst](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->