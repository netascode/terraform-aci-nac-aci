<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-l2-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-l2-policy/actions/workflows/test.yml)

# Terraform ACI L2 Policy Module

Manages ACI L2 Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `L2 Interface`

## Examples

```hcl
module "aci_l2_policy" {
  source  = "netascode/l2-policy/aci"
  version = ">= 0.1.0"

  name             = "L2POL1"
  vlan_scope       = "portlocal"
  qinq             = "edgePort"
  reflective_relay = true
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
| <a name="input_name"></a> [name](#input\_name) | L2 interface policy name. | `string` | n/a | yes |
| <a name="input_vlan_scope"></a> [vlan\_scope](#input\_vlan\_scope) | VLAN scope. Choices: `global`, `portlocal`. | `string` | `"global"` | no |
| <a name="input_qinq"></a> [qinq](#input\_qinq) | QinQ mode. Choices: `disabled`, `edgePort`, `corePort`, `doubleQtagPort`. | `string` | `"disabled"` | no |
| <a name="input_reflective_relay"></a> [reflective\_relay](#input\_reflective\_relay) | Reflective Relay (802.1Qbg) | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `l2IfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | L2 interface policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.l2IfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->