<!-- BEGIN_TF_DOCS -->
# Terraform ACI Interface Type Module

Manages Interface Type

Location in GUI:
`Fabric` » `Inventory` » `Pod XXX` » `Node XXX` » `Interface`

## Examples

```hcl
module "aci_interface_type" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-interface-type"
  version = ">= 0.8.0"

  pod_id  = 2
  node_id = 101
  module  = 2
  port    = 1
  type    = "downlink"
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
| <a name="input_pod_id"></a> [pod\_id](#input\_pod\_id) | Interface Pod ID. Minimum value: `1`. Maximum value: `255`. | `number` | `1` | no |
| <a name="input_node_id"></a> [node\_id](#input\_node\_id) | Interface Node ID. Minimum value: `1`. Maximum value: `4000`. | `number` | n/a | yes |
| <a name="input_module"></a> [module](#input\_module) | Interface Module. Minimum value: `1`. Maximum value: `9`. | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Interface Port. Minimum value: `1`. Maximum value: `127`. | `number` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Interface Type. Valid values are `uplink` or `downlink` | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraRsPortDirection` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.infraRsPortDirection](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->