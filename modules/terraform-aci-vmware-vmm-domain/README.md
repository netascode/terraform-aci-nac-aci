<!-- BEGIN_TF_DOCS -->
# Terraform ACI VMware VMM Domain Module

Manages ACI VMware VMM Domain

Location in GUI:
`Virtual Networking` » `VMware`

## Examples

```hcl
module "aci_vmware_vmm_domain" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-vmware-vmm-domain"
  version = ">= 0.8.0"

  name                        = "VMW1"
  access_mode                 = "read-only"
  delimiter                   = "="
  tag_collection              = true
  vlan_pool                   = "VP1"
  allocation                  = "static"
  vswitch_cdp_policy          = "CDP1"
  vswitch_lldp_policy         = "LLDP1"
  vswitch_port_channel_policy = "PC1"
  vswitch_mtu_policy          = "L2-8950"
  security_domains            = ["SEC1"]
  vswitch_enhanced_lags = [
    {
      name    = "ELAG1"
      mode    = "passive"
      lb_mode = "dst-ip-l4port"
    },
    {
      name = "ELAG2"
    }
  ]
  vcenters = [{
    name              = "VC1"
    hostname_ip       = "1.1.1.1"
    datacenter        = "DC"
    credential_policy = "CP1"
    dvs_version       = "6.5"
    statistics        = true
    mgmt_epg_type     = "oob"
  }]
  credential_policies = [{
    name     = "CP1"
    username = "USER1"
    password = "PASSWORD1"
  }]
  uplinks = [
    {
      id   = 1
      name = "UL1"
    },
    {
      id   = 2
      name = "UL2"
    }
  ]
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
| <a name="input_name"></a> [name](#input\_name) | VMware VMM domain name. | `string` | n/a | yes |
| <a name="input_access_mode"></a> [access\_mode](#input\_access\_mode) | Access mode. Choices: `read-only`, `read-write`. | `string` | `"read-write"` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter (vCenter Port Group). | `string` | `""` | no |
| <a name="input_tag_collection"></a> [tag\_collection](#input\_tag\_collection) | Tag collection. | `bool` | `false` | no |
| <a name="input_vlan_pool"></a> [vlan\_pool](#input\_vlan\_pool) | Vlan pool name. | `string` | n/a | yes |
| <a name="input_allocation"></a> [allocation](#input\_allocation) | Vlan pool allocation mode. Choices: `static`, `dynamic`. | `string` | `"dynamic"` | no |
| <a name="input_vswitch_cdp_policy"></a> [vswitch\_cdp\_policy](#input\_vswitch\_cdp\_policy) | vSwitch CDP policy name. | `string` | `""` | no |
| <a name="input_vswitch_lldp_policy"></a> [vswitch\_lldp\_policy](#input\_vswitch\_lldp\_policy) | vSwitch LLDP policy name. | `string` | `""` | no |
| <a name="input_vswitch_port_channel_policy"></a> [vswitch\_port\_channel\_policy](#input\_vswitch\_port\_channel\_policy) | vSwitch port channel policy name. | `string` | `""` | no |
| <a name="input_vswitch_mtu_policy"></a> [vswitch\_mtu\_policy](#input\_vswitch\_mtu\_policy) | vSwitch MTU policy name. | `string` | `""` | no |
| <a name="input_vswitch_netflow_policy"></a> [vswitch\_netflow\_policy](#input\_vswitch\_netflow\_policy) | vSwitch NetFlow Exporter policy name. | `string` | `""` | no |
| <a name="input_vswitch_enhanced_lags"></a> [vswitch\_enhanced\_lags](#input\_vswitch\_enhanced\_lags) | vSwitch enhanced lags. Allowed values for `lb_mode`: `dst-ip`, `dst-ip-l4port`, `dst-ip-vlan`, `dst-ip-l4port-vlan`, `dst-mac`, `dst-l4port`, `src-ip`, `src-ip-l4port`, `src-ip-vlan`, `src-ip-l4port-vlan`, `src-mac`, `src-l4port`, `src-dst-ip`, `src-dst-ip-l4port`, `src-dst-ip-vlan`, `src-dst-ip-l4port-vlan`, `src-dst-mac`, `src-dst-l4port`, `src-port-id` or `vlan`. Default value: `src-dst-ip`. Allowed values for `mode`: `active` or `passive`. Defautl value: `active`. Allowed range for `num_links`: 2-8. | <pre>list(object({<br/>    name      = string<br/>    lb_mode   = optional(string, "src-dst-ip")<br/>    mode      = optional(string, "active")<br/>    num_links = optional(number, 2)<br/>  }))</pre> | `[]` | no |
| <a name="input_vcenters"></a> [vcenters](#input\_vcenters) | List of vCenter hosts. Choices `dvs_version`: `unmanaged`, `5.1`, `5.5`, `6.0`, `6.5`, `6.6`, `7.0`. Default value `dvs_version`: `unmanaged`. Default value `statistics`: false. Allowed values `mgmt_epg_type`: `inb`, `oob`. Default value `mgmt_epg_type`: `inb`. | <pre>list(object({<br/>    name              = string<br/>    hostname_ip       = string<br/>    datacenter        = string<br/>    credential_policy = optional(string)<br/>    dvs_version       = optional(string, "unmanaged")<br/>    statistics        = optional(bool, false)<br/>    mgmt_epg_type     = optional(string, "inb")<br/>    mgmt_epg_name     = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_credential_policies"></a> [credential\_policies](#input\_credential\_policies) | List of vCenter credentials. | <pre>list(object({<br/>    name     = string<br/>    username = string<br/>    password = string<br/>  }))</pre> | `[]` | no |
| <a name="input_uplinks"></a> [uplinks](#input\_uplinks) | List of vSwitch uplinks. Allowed range for `id`: 1-32. | <pre>list(object({<br/>    id   = number<br/>    name = string<br/>  }))</pre> | `[]` | no |
| <a name="input_security_domains"></a> [security\_domains](#input\_security\_domains) | Security domains associated to VMware VMM domain | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vmmDomP` object. |
| <a name="output_name"></a> [name](#output\_name) | VMware VMM domain name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.aaaDomainRef](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsVlanNs](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.lacpEnhancedLagPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmCtrlrP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmDomP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmRsAcc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmRsMgmtEPg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmRsVswitchExporterPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmRsVswitchOverrideCdpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmRsVswitchOverrideLacpPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmRsVswitchOverrideLldpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmRsVswitchOverrideMtuPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmUplinkP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmUplinkPCont](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmUsrAccP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmmVSwitchPolicyCont](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->