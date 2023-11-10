<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-port-channel-member-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-port-channel-member-policy/actions/workflows/test.yml)

# Terraform ACI Port Channel Member Policy Module

Manages ACI Port Channel Member Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Port Channel Member`

## Examples

```hcl
module "aci_port_channel_member_policy" {
  source  = "netascode/port-channel-member-policy/aci"
  version = ">= 0.1.0"

  name     = "FAST"
  priority = 10
  rate     = "fast"
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
| <a name="input_name"></a> [name](#input\_name) | Port channel member policy name. | `string` | n/a | yes |
| <a name="input_priority"></a> [priority](#input\_priority) | Priority. Minimum value: 1. Maximum value: 65535. | `number` | `32768` | no |
| <a name="input_rate"></a> [rate](#input\_rate) | Rate. Choices: `normal`, `fast`. | `string` | `"normal"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `lacpIfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Port channel member policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.lacpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->