<!-- BEGIN_TF_DOCS -->
# Terraform ACI Interface Shutdown Module

Manages Interface Shutdown

Location in GUI:
`Fabric` » `Inventory` » `Pod XXX` » `Node XXX` » `Interface`

## Examples

```hcl
module "aci_interface_shutdown" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-interface-shutdown"
  version = ">= 0.9.2"

  pod_id  = 1
  node_id = 101
  module  = 1
  port    = 1
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
| <a name="input_node_id"></a> [node\_id](#input\_node\_id) | Interface Node ID. Minimum value: `101`. Maximum value: `4000`. | `number` | n/a | yes |
| <a name="input_module"></a> [module](#input\_module) | Interface Module. Minimum value: `1`. Maximum value: `255`. | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Interface Port. Minimum value: `1`. Maximum value: `127`. | `number` | n/a | yes |
| <a name="input_sub_port"></a> [sub\_port](#input\_sub\_port) | Interface Sub-Port. Allowed values: 1-64. `0` meaning no Sub-Port. | `number` | `0` | no |
| <a name="input_fex_id"></a> [fex\_id](#input\_fex\_id) | Interface FEX ID. Allowed values: 101-199. `0` meaning no FEX. | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fabricRsOosPath` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricRsOosPath](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->