<!-- BEGIN_TF_DOCS -->
# Terraform ACI BFD Multihop Node Policy Module

Description

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BFD Multihop` » `Node Policies`

## Examples

```hcl
module "aci_bfd_multihop_node_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bfd-multihop-node-policy"
  version = ">= 0.8.0"

  tenant               = "ABC"
  name                 = "BFD-MHOP"
  description          = "My Description"
  detection_multiplier = 10
  min_rx_interval      = 100
  min_tx_interval      = 100
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | BFD Multihop Node policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_detection_multiplier"></a> [detection\_multiplier](#input\_detection\_multiplier) | Detection multiplier. Minimum value: 1. Maximum value: 50. | `number` | `3` | no |
| <a name="input_min_rx_interval"></a> [min\_rx\_interval](#input\_min\_rx\_interval) | Min RX interval. Minimum value: 50. Maximum value: 999. | `number` | `250` | no |
| <a name="input_min_tx_interval"></a> [min\_tx\_interval](#input\_min\_tx\_interval) | Min TX interval. Minimum value: 50. Maximum value: 999. | `number` | `250` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `bfdMhNodePol` object. |
| <a name="output_name"></a> [name](#output\_name) | BFD Multihop node policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.bfdMhNodePol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->