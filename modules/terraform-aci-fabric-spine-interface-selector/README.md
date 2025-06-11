<!-- BEGIN_TF_DOCS -->
# Terraform ACI Fabric Leaf Interface Selector Module

Manages ACI Fabric Leaf Interface Selector

Location in GUI:
`Fabric` » `Fabric Policies` » `Interfaces` » `Leaf Interfaces` » `Profiles` » `XXX`

## Examples

```hcl
module "aci_access_leaf_interface_selector" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-leaf-interface-selector"
  version = ">= 1.0.1"

  interface_profile = "LEAF101"
  name              = "1-2"
  policy_group      = "FAB1"
  port_blocks = [{
    name        = "PB1"
    description = "My Description"
    from_port   = 1
    to_port     = 2
  }]
  sub_port_blocks = [{
    name          = "SPB1"
    description   = "My Description"
    from_port     = 1
    from_sub_port = 1
    to_sub_port   = 2
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.15.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_interface_profile"></a> [interface\_profile](#input\_interface\_profile) | Spine interface profile name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Interface selector description. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Spine interface selector name. | `string` | n/a | yes |
| <a name="input_policy_group"></a> [policy\_group](#input\_policy\_group) | Interface policy group name. | `string` | `""` | no |
| <a name="input_port_blocks"></a> [port\_blocks](#input\_port\_blocks) | List of port blocks. Allowed values `from_module`, `to_module`: 1-9. Default value `from_module`, `to_module`: 1. Allowed values `from_port`, `to_port`: 1-127. Default value `to_port`: `from_port`. | <pre>list(object({<br/>    name        = string<br/>    description = optional(string, "")<br/>    from_module = optional(number, 1)<br/>    to_module   = optional(number)<br/>    from_port   = number<br/>    to_port     = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_sub_port_blocks"></a> [sub\_port\_blocks](#input\_sub\_port\_blocks) | List of sub port blocks. Allowed values `from_module`, `to_module`: 1-9. Default value `from_module`, `to_module`: 1. Allowed values `from_port`, `to_port`: 1-127. Default value `to_port`: `from_port`. Allowed values `from_sub_port`, `to_sub_port`: 1-16. Default value `to_sub_port`: `from_sub_port`. | <pre>list(object({<br/>    name          = string<br/>    description   = optional(string, "")<br/>    from_module   = optional(number, 1)<br/>    to_module     = optional(number)<br/>    from_port     = number<br/>    to_port       = optional(number)<br/>    from_sub_port = number<br/>    to_sub_port   = optional(number)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fabricLFPortS` object. |
| <a name="output_name"></a> [name](#output\_name) | Spine interface selector name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricLFPortS](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricPortBlk](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricRsLePortPGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricSubPortBlk](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->