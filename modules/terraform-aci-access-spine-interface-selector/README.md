<!-- BEGIN_TF_DOCS -->
# Terraform ACI Access Spine Interface Selector Module

Manages ACI Access Spine Interface Selector

Location in GUI:
`Fabric` » `Access Policies` » `Interfaces` » `Spine Interfaces` » `Profiles` » `XXX`

## Examples

```hcl
module "aci_access_spine_interface_selector" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-spine-interface-selector"
  version = ">= 0.8.0"

  interface_profile = "SPINE1001"
  name              = "1-2"
  policy_group      = "ACC1"
  port_blocks = [{
    name        = "PB1"
    description = "My Description"
    from_port   = 1
    to_port     = 2
  }]
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
| <a name="input_interface_profile"></a> [interface\_profile](#input\_interface\_profile) | Spine interface profile name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Spine interface selector name. | `string` | n/a | yes |
| <a name="input_policy_group"></a> [policy\_group](#input\_policy\_group) | Interface policy group name. | `string` | `""` | no |
| <a name="input_port_blocks"></a> [port\_blocks](#input\_port\_blocks) | List of port blocks. Allowed values `from_module`, `to_module`: 1-9. Default value `from_module`, `to_module`: 1. Allowed values `from_port`, `to_port`: 1-127. Default value `to_port`: `from_port`. | <pre>list(object({<br/>    name        = string<br/>    description = optional(string, "")<br/>    from_module = optional(number, 1)<br/>    to_module   = optional(number)<br/>    from_port   = number<br/>    to_port     = optional(number)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraSHPortS` object. |
| <a name="output_name"></a> [name](#output\_name) | Spine interface selector name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.infraPortBlk](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraRsSpAccGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraSHPortS](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->