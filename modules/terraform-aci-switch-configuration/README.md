<!-- BEGIN_TF_DOCS -->
# Terraform ACI Switch Configuration Module

Manages ACI Switch Configuration

Location in GUI:
`Fabric` » `Access Policies` » `Switch Configuration`

## Examples

```hcl
module "aci_switch_configuration" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-switch-configuration"
  version = ">= 0.8.0"

  node_id             = 101
  role                = "leaf"
  access_policy_group = "LFACC1"
  fabric_policy_group = "LFFAB1"
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
| <a name="input_node_id"></a> [node\_id](#input\_node\_id) | Node ID. Allowed values: 101-16000. | `number` | n/a | yes |
| <a name="input_access_policy_group"></a> [access\_policy\_group](#input\_access\_policy\_group) | Access switch policy group name. | `string` | `""` | no |
| <a name="input_fabric_policy_group"></a> [fabric\_policy\_group](#input\_fabric\_policy\_group) | Fabric switch policy group name. | `string` | `""` | no |
| <a name="input_role"></a> [role](#input\_role) | Node role. Allowed values: `leaf`, `spine`. | `string` | `"leaf"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_dn"></a> [access\_dn](#output\_access\_dn) | Distinguished name of `infraNodeConfig` object. |
| <a name="output_fabric_dn"></a> [fabric\_dn](#output\_fabric\_dn) | Distinguished name of `fabricNodeConfig` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricNodeConfig](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.infraNodeConfig](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->