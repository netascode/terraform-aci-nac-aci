<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-access-leaf-interface-policy-group/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-access-leaf-interface-policy-group/actions/workflows/test.yml)

# Terraform ACI Access Leaf Interface Policy Group Module

Manages ACI Access Leaf Interface Policy Group

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Leaf Interfaces` » `Policy Groups`

## Examples

```hcl
module "aci_access_leaf_interface_policy_group" {
  source  = "netascode/access-leaf-interface-policy-group/aci"
  version = ">= 0.1.4"

  name                       = "VPC1"
  description                = "VPC Interface Policy Group 1"
  type                       = "vpc"
  link_level_policy          = "10G"
  cdp_policy                 = "CDP-ON"
  lldp_policy                = "LLDP-OFF"
  spanning_tree_policy       = "BPDU-GUARD"
  mcp_policy                 = "MCP-ON"
  l2_policy                  = "PORT-LOCAL"
  storm_control_policy       = "10P"
  port_channel_policy        = "LACP"
  port_channel_member_policy = "FAST"
  aaep                       = "AAEP1"
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
| <a name="input_name"></a> [name](#input\_name) | Leaf interface policy group name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_type"></a> [type](#input\_type) | Type. Choices: `access`, `vpc`, `pc`, `breakout`. | `string` | `"access"` | no |
| <a name="input_map"></a> [map](#input\_map) | Breakout map. Only relevant if `type` is `breakout`. Choices: `none`, `10g-4x`, `25g-4x`, `100g-2x`, `50g-8x`, `100g-4x`. | `string` | `"none"` | no |
| <a name="input_link_level_policy"></a> [link\_level\_policy](#input\_link\_level\_policy) | Link level policy name. | `string` | `""` | no |
| <a name="input_cdp_policy"></a> [cdp\_policy](#input\_cdp\_policy) | CDP policy name. | `string` | `""` | no |
| <a name="input_lldp_policy"></a> [lldp\_policy](#input\_lldp\_policy) | LLDP policy name. | `string` | `""` | no |
| <a name="input_spanning_tree_policy"></a> [spanning\_tree\_policy](#input\_spanning\_tree\_policy) | Spanning tree policy name. | `string` | `""` | no |
| <a name="input_mcp_policy"></a> [mcp\_policy](#input\_mcp\_policy) | MCP policy name. | `string` | `""` | no |
| <a name="input_l2_policy"></a> [l2\_policy](#input\_l2\_policy) | L2 policy name. | `string` | `""` | no |
| <a name="input_storm_control_policy"></a> [storm\_control\_policy](#input\_storm\_control\_policy) | Storm control policy name. | `string` | `""` | no |
| <a name="input_port_channel_policy"></a> [port\_channel\_policy](#input\_port\_channel\_policy) | Port channel policy name. | `string` | `""` | no |
| <a name="input_port_channel_member_policy"></a> [port\_channel\_member\_policy](#input\_port\_channel\_member\_policy) | Port channel member policy name. | `string` | `""` | no |
| <a name="input_aaep"></a> [aaep](#input\_aaep) | Attachable access entity profile name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraAccGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | Leaf interface policy group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.infraAccBndlSubgrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraAccGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsAttEntP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsCdpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsHIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsL2IfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsLacpInterfacePol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsLacpPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsLldpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsMcpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsStormctrlIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsStpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->