<!-- BEGIN_TF_DOCS -->
# Terraform ACI Fabric Interface Configuration Module

Manages ACI Fabric Interface Configuration

Location in GUI:
`Fabric` » `Access Policies` » `Interface Configuration`

## Examples

```hcl
module "aci_fabric_interface_configuration" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-interface-configuration"
  version = ">= 0.8.0"

  node_id      = 101
  policy_group = "FAB1"
  description  = "Port description"
  port         = 49
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
| <a name="input_module"></a> [module](#input\_module) | Module ID. Allowed values: 1-255. | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Interface ID. Allowed values: 1-127. | `number` | `1` | no |
| <a name="input_sub_port"></a> [sub\_port](#input\_sub\_port) | Subinterface ID. Allowed values: 1-64. | `number` | `0` | no |
| <a name="input_policy_group"></a> [policy\_group](#input\_policy\_group) | Interface policy group name. | `string` | `"system-ports-default"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_role"></a> [role](#input\_role) | Node role. Allowed values: `leaf`, `spine`. | `string` | `"leaf"` | no |
| <a name="input_shutdown"></a> [shutdown](#input\_shutdown) | Shutdown interface. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fabricPortConfig` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricPortConfig](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->