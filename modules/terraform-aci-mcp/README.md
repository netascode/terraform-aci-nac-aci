<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-mcp/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-mcp/actions/workflows/test.yml)

# Terraform ACI MCP Module

Description

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Global` » `MCP Instance Policy default`

## Examples

```hcl
module "aci_mcp" {
  source  = "netascode/mcp/aci"
  version = ">= 0.1.0"

  admin_state         = true
  per_vlan            = true
  initial_delay       = 200
  key                 = "$ECRETKEY1"
  loop_detection      = 5
  disable_port_action = true
  frequency_sec       = 0
  frequency_msec      = 100
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
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | Admin state. | `bool` | `false` | no |
| <a name="input_per_vlan"></a> [per\_vlan](#input\_per\_vlan) | Per VLAN. | `bool` | `false` | no |
| <a name="input_initial_delay"></a> [initial\_delay](#input\_initial\_delay) | Initial delay. | `number` | `180` | no |
| <a name="input_key"></a> [key](#input\_key) | Key. | `string` | `""` | no |
| <a name="input_loop_detection"></a> [loop\_detection](#input\_loop\_detection) | Loop detection. | `number` | `3` | no |
| <a name="input_disable_port_action"></a> [disable\_port\_action](#input\_disable\_port\_action) | Disable port action. | `bool` | `true` | no |
| <a name="input_frequency_sec"></a> [frequency\_sec](#input\_frequency\_sec) | Frequency in seconds. | `number` | `2` | no |
| <a name="input_frequency_msec"></a> [frequency\_msec](#input\_frequency\_msec) | Frequency in milliseconds. | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `mcpInstPol` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.mcpInstPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->