<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-endpoint-loop-protection/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-endpoint-loop-protection/actions/workflows/test.yml)

# Terraform ACI Endpoint Loop Protection Module

Manages ACI Endpoint Loop Protection

Location in GUI:
`System` » `System Settings` » `Endpoint Controls`

## Examples

```hcl
module "aci_endpoint_loop_protection" {
  source  = "netascode/endpoint-loop-protection/aci"
  version = ">= 0.1.0"

  action               = "bd-learn-disable"
  admin_state          = true
  detection_interval   = 90
  detection_multiplier = 10
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
| <a name="input_action"></a> [action](#input\_action) | Action. Choices: `bd-learn-disable`, `port-disable`. | `string` | `"port-disable"` | no |
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | Admin state. | `bool` | `false` | no |
| <a name="input_detection_interval"></a> [detection\_interval](#input\_detection\_interval) | Detection interval. Minimum value: 30. Maximum value: 300. | `number` | `60` | no |
| <a name="input_detection_multiplier"></a> [detection\_multiplier](#input\_detection\_multiplier) | Detection multiplier. Minimum value: 1. Maximum value: 255. | `number` | `4` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `epLoopProtectP` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.epLoopProtectP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->