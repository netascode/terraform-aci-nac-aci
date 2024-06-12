<!-- BEGIN_TF_DOCS -->
# Terraform ACI Maintenance Group Module

Manages ACI Maintenance Group

Location in GUI:
`Admin` » `Firmware` » `Nodes`

## Examples

```hcl
module "aci_maintenance_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-maintenance-group"
  version = ">= 0.8.0"

  name     = "UG1"
  node_ids = [101]
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
| <a name="input_name"></a> [name](#input\_name) | Maintenance group name. | `string` | n/a | yes |
| <a name="input_target_version"></a> [target\_version](#input\_target\_version) | Target version. | `string` | `""` | no |
| <a name="input_node_ids"></a> [node\_ids](#input\_node\_ids) | List of node IDs. Minimum value: 1. Maximum value: 4000. | `list(number)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `maintMaintGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | Maintenance group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricNodeBlk](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.maintMaintGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.maintMaintP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.maintRsMgrpp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.maintRsPolScheduler](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->