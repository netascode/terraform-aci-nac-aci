<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-node-registration/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-node-registration/actions/workflows/test.yml)

# Terraform ACI Node Registration Module

Manages ACI Node Registration

Location in GUI:
`Fabric` » `Inventory` » `Fabric Membership`

## Examples

```hcl
module "aci_node_registration" {
  source  = "netascode/node-registration/aci"
  version = ">= 0.1.1"

  name           = "LEAF105"
  node_id        = 105
  pod_id         = 2
  serial_number  = "ABCDEFGHIJKLMN"
  type           = "remote-leaf-wan"
  remote_pool_id = 2
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
| <a name="input_name"></a> [name](#input\_name) | Node name. | `string` | n/a | yes |
| <a name="input_node_id"></a> [node\_id](#input\_node\_id) | Node ID. Minimum value: 1. Maximum value: 4000. | `number` | n/a | yes |
| <a name="input_pod_id"></a> [pod\_id](#input\_pod\_id) | Pod ID. Minimum value: 1. Maximum value: 255. | `number` | `1` | no |
| <a name="input_serial_number"></a> [serial\_number](#input\_serial\_number) | Serial number. | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Node type. Choices: `remote-leaf-wan`, `virtual`, `tier-2-leaf`, `unspecified`. | `string` | `"unspecified"` | no |
| <a name="input_remote_pool_id"></a> [remote\_pool\_id](#input\_remote\_pool\_id) | Remote Pool ID. Minimum value: 0. Maximum value: 255 | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fabricNodeIdentP` object. |
| <a name="output_name"></a> [name](#output\_name) | Node name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricNodeIdentP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->