<!-- BEGIN_TF_DOCS -->
# Terraform ACI Priority Flow Control Policy

Manages ACI Priority Flow Control Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `Priority Flow Control`

## Examples

```hcl
module "aci_priority_flow_control_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-priority-flow-control-policy"
  version = "> 1.2.0"

  name        = "PFC_ON"
  description = "PFC enabled"
  admin_state = true
  auto_state  = false
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
| <a name="input_name"></a> [name](#input\_name) | Priority flow control policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | Admin state. When `auto_state` is false, this determines the state: true = on, false = off. | `bool` | `true` | no |
| <a name="input_auto_state"></a> [auto\_state](#input\_auto\_state) | Auto state. When true, PFC is set to auto mode. When false, `admin_state` determines on/off. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `qosPfcIfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Priority flow control policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.qosPfcIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->