<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-error-disabled-recovery/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-error-disabled-recovery/actions/workflows/test.yml)

# Terraform ACI Error Disabled Recovery Module

Manages ACI Error Disabled Recovery

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Global` » `Error Disabled Recovery Policy`

## Examples

```hcl
module "aci_error_disabled_recovery" {
  source  = "netascode/error-disabled-recovery/aci"
  version = ">= 0.1.0"

  interval   = 600
  mcp_loop   = true
  ep_move    = true
  bpdu_guard = true
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
| <a name="input_interval"></a> [interval](#input\_interval) | Interval. Minimum value: 30. Maximum value: 65535. | `number` | `300` | no |
| <a name="input_mcp_loop"></a> [mcp\_loop](#input\_mcp\_loop) | MCP loop recovery. | `bool` | `false` | no |
| <a name="input_ep_move"></a> [ep\_move](#input\_ep\_move) | EP move recovery. | `bool` | `false` | no |
| <a name="input_bpdu_guard"></a> [bpdu\_guard](#input\_bpdu\_guard) | BPDU guard recovery. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `edrErrDisRecoverPol` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.edrErrDisRecoverPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.edrEventP-event-bpduguard](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.edrEventP-event-ep-move](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.edrEventP-event-mcp-loop](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->