<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-mcp-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-mcp-policy/actions/workflows/test.yml)

# Terraform ACI MCP Policy Module

Manages ACI MCP Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `MCP Interface`

## Examples

```hcl
module "aci_mcp_policy" {
  source  = "netascode/mcp-policy/aci"
  version = ">= 0.1.0"

  name        = "MCP-OFF"
  admin_state = false
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