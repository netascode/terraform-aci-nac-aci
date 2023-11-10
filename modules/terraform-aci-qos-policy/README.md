<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-qos-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-scaffolding/actions/workflows/test.yml)

# Terraform ACI QoS Custom Policy Module

Manages ACI QoS Custom Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `Custom QoS`

## Examples

```hcl
module "aci_qos_policy" {
  source  = "netascode/qos-policy/aci"
  version = ">= 0.1.0"

  name        = "ABC"
  tenant      = "TEN1"
  description = "My Custom Policy"
  alias       = "MyAlias"
  dscp_priority_maps = [
    {
      dscp_from   = "AF12"
      dscp_to     = "AF13"
      priority    = "level5"
      dscp_target = "CS0"
      cos_target  = 5
    }
  ]
  dot1p_classifiers = [
    {
      dot1p_from  = 3
      dot1p_to    = 4
      priority    = "level5"
      dscp_target = "CS0"
      cos_target  = 5
    }
  ]
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
| <a name="input_name"></a> [name](#input\_name) | QoS Policy name. | `string` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | QoS Policy alias. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | QoS Policy description. | `string` | `""` | no |
| <a name="input_dscp_priority_maps"></a> [dscp\_priority\_maps](#input\_dscp\_priority\_maps) | QoS Policy DSCP Priority Maps. Allowed values `dscp_from`, `dscp_to` and `dscp_target` : `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6` `CS7` or a number between 0 and 63. Allowed values `priority`: `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`. Allowed values `cos_target`: `unspecified` or a number between 0 and 7. | <pre>list(object({<br>    dscp_from   = string<br>    dscp_to     = optional(string)<br>    priority    = optional(string, "level3")<br>    dscp_target = optional(string, "unspecified")<br>    cos_target  = optional(string, "unspecified")<br>  }))</pre> | `[]` | no |
| <a name="input_dot1p_classifiers"></a> [dot1p\_classifiers](#input\_dot1p\_classifiers) | QoS Policy DSCP Dot1p Classifiers. Allowed values `dot1p_from`, `dot1p_to` and `cos_target`: `unspecified` or a number between 0 and 7. Allowed values `dscp_target` : `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63. Allowed values `priority`: `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`. | <pre>list(object({<br>    dot1p_from  = string<br>    dot1p_to    = optional(string)<br>    priority    = optional(string, "level3")<br>    dscp_target = optional(string, "unspecified")<br>    cos_target  = optional(string, "unspecified")<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `qosCustomPol` object. |
| <a name="output_name"></a> [name](#output\_name) | QoS Custom Policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.qosCustomPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.qosDot1PClass](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.qosDscpClass](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->