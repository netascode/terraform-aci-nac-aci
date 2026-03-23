<!-- BEGIN_TF_DOCS -->
# Terraform ACI VXLAN Custom QoS Policy Module

Description

Location in GUI:
`Tenants` » `infra` » `Policies` » `Protocol` » `VXLAN Custom QoS Policy`

## Examples

```hcl
module "aci_vxlan_custom_qos_policy" {
  source  = "netascode/nac-aci/aci/modules/terraform-aci-vxlan-custom-qos-policy"
  version = "> 1.2.0"

  name        = "vxlan_QOS_POL"
  description = "Custom vxlan QoS Policy"
  ingress_rules = [
    {
      priority    = "level1"
      exp_from    = 1
      exp_to      = 2
      dscp_target = "AF11"
      cos_target  = 0
    }
  ]
  egress_rules = [
    {
      dscp_from  = "AF11"
      dscp_to    = "AF12"
      exp_target = 0
      cos_target = 0
    }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.17.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Vxlan Custom QoS Policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Vxlan Custom QoS Policy description. | `string` | `""` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | QoS Policy DSCP Priority Maps. Allowed values `priority`: `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`. Allowed values `exp_from`, `exp_to` and `cos_target`: `unspecified` or a number between 0 and 7. Allowed values `dscp_target` : `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63. | <pre>list(object({<br/>    priority    = optional(string, "unspecified")<br/>    dscp_from   = string<br/>    dscp_to     = string<br/>    dscp_target = optional(string, "unspecified")<br/>    cos_target  = optional(string, "unspecified")<br/>  }))</pre> | `[]` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | QoS Policy DSCP Dot1p Classifiers. Allowed values `dscp_target` and `cos_target`: `unspecified` or a number between 0 and 7. Allowed values `dscp_from` and `dscp_to` : `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63. | <pre>list(object({<br/>    dscp_from   = string<br/>    dscp_to     = string<br/>    dscp_target = optional(string, "unspecified")<br/>    cos_target  = optional(string, "unspecified")<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `qosVxlanCustomPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Vxlan Custom QoS Policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.qosVxlanCustomPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.qosVxlanEgressRule](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.qosVxlanIngressRule](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->