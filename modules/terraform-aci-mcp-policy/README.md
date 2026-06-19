<!-- BEGIN_TF_DOCS -->
# Terraform ACI MCP Policy Module

Manages ACI MCP Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `MCP Interface`

## Examples

```hcl
module "aci_mcp_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-mcp-policy"
  version = ">= 0.8.0"

  name              = "MCP-STRICT"
  admin_state       = true
  per_vlan_mcp      = true
  strict_mode       = true
  max_vlans         = 256
  grace_period      = 5
  grace_period_msec = 500
  initial_delay     = 180
  frequency_sec     = 2
  frequency_msec    = 0
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
| <a name="input_name"></a> [name](#input\_name) | MCP policy name. | `string` | n/a | yes |
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | Admin state. | `bool` | `true` | no |
| <a name="input_per_vlan_mcp"></a> [per\_vlan\_mcp](#input\_per\_vlan\_mcp) | Per-VLAN MCP PDU transmission (`mcpPduPerVlan`). | `bool` | `true` | no |
| <a name="input_strict_mode"></a> [strict\_mode](#input\_strict\_mode) | MCP strict mode (`mcpMode`). When `true`, emits `mcpMode=on`. When `false`, emits `mcpMode=off`. | `bool` | `false` | no |
| <a name="input_max_vlans"></a> [max\_vlans](#input\_max\_vlans) | Max VLAN counter for per-VLAN PDU bursts. When `strict_mode` is `true`, the effective value is capped at 256. Minimum value: 1. Maximum value: 2000. | `number` | `256` | no |
| <a name="input_grace_period"></a> [grace\_period](#input\_grace\_period) | MCP strict-mode grace period in seconds. Minimum value: 0. Maximum value: 300. | `number` | `3` | no |
| <a name="input_grace_period_msec"></a> [grace\_period\_msec](#input\_grace\_period\_msec) | MCP strict-mode grace period in milliseconds. Minimum value: 0. Maximum value: 999. | `number` | `0` | no |
| <a name="input_initial_delay"></a> [initial\_delay](#input\_initial\_delay) | MCP strict-mode initial delay in seconds. Minimum value: 0. Maximum value: 1800. | `number` | `0` | no |
| <a name="input_frequency_sec"></a> [frequency\_sec](#input\_frequency\_sec) | MCP strict-mode transmit frequency in seconds. Minimum value: 0. Maximum value: 300. | `number` | `0` | no |
| <a name="input_frequency_msec"></a> [frequency\_msec](#input\_frequency\_msec) | MCP strict-mode transmit frequency in milliseconds. Minimum value: 0. Maximum value: 999. | `number` | `500` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `mcpIfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | MCP policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.mcpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->