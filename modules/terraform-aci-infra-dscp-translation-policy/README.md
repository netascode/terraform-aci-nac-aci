<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-infra-dscp-translation-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-infra-dscp-translation-policy/actions/workflows/test.yml)

# Terraform ACI Infra DSCP Translation Policy Module

Manages ACI Infra DSCP Translation Policy

Location in GUI:
`Tenants` » `infra` » `Policies` » `Protocol` » `DSCP class-CoS translation policy for L3 traffic`

## Examples

```hcl
module "aci_infra_dscp_translation_policy" {
  source  = "netascode/infra-dscp-translation-policy/aci"
  version = ">= 0.1.0"

  admin_state   = true
  control_plane = "CS1"
  level_1       = "CS2"
  level_2       = "CS3"
  level_3       = "CS4"
  level_4       = "CS5"
  level_5       = "CS6"
  level_6       = "CS7"
  policy_plane  = "AF11"
  span          = "AF12"
  traceroute    = "AF13"
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
| <a name="input_control_plane"></a> [control\_plane](#input\_control\_plane) | Control plane. Allowed values: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, number between 0 and 63. | `string` | `"CS0"` | no |
| <a name="input_level_1"></a> [level\_1](#input\_level\_1) | Level 1. Allowed values: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, number between 0 and 63. | `string` | `"CS1"` | no |
| <a name="input_level_2"></a> [level\_2](#input\_level\_2) | Level 2. Allowed values: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, number between 0 and 63. | `string` | `"CS2"` | no |
| <a name="input_level_3"></a> [level\_3](#input\_level\_3) | Level 3. Allowed values: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, number between 0 and 63. | `string` | `"CS3"` | no |
| <a name="input_level_4"></a> [level\_4](#input\_level\_4) | Level 4. Allowed values: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, number between 0 and 63. | `string` | `"AF11"` | no |
| <a name="input_level_5"></a> [level\_5](#input\_level\_5) | Level 5. Allowed values: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, number between 0 and 63. | `string` | `"AF21"` | no |
| <a name="input_level_6"></a> [level\_6](#input\_level\_6) | Level 6. Allowed values: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, number between 0 and 63. | `string` | `"AF31"` | no |
| <a name="input_policy_plane"></a> [policy\_plane](#input\_policy\_plane) | Policy plane. Allowed values: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, number between 0 and 63. | `string` | `"CS4"` | no |
| <a name="input_span"></a> [span](#input\_span) | SPAN. Allowed values: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, number between 0 and 63. | `string` | `"CS5"` | no |
| <a name="input_traceroute"></a> [traceroute](#input\_traceroute) | Traceroute. Allowed values: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, number between 0 and 63. | `string` | `"CS6"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `qosDscpTransPol` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.qosDscpTransPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->