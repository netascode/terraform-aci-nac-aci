<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-bfd-interface-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-bfd-interface-policy/actions/workflows/test.yml)

# Terraform ACI BFD Interface Policy Module

Manages ACI BFD Interface Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `BFD`

## Examples

```hcl
module "aci_bfd_interface_policy" {
  source  = "netascode/bfd-interface-policy/aci"
  version = ">= 0.1.0"

  tenant                    = "ABC"
  name                      = "BFD1"
  description               = "My Description"
  subinterface_optimization = true
  detection_multiplier      = 10
  echo_admin_state          = true
  echo_rx_interval          = 100
  min_rx_interval           = 100
  min_tx_interval           = 100
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
| <a name="input_name"></a> [name](#input\_name) | BFD interface policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_subinterface_optimization"></a> [subinterface\_optimization](#input\_subinterface\_optimization) | Subinterface optimization. | `bool` | `false` | no |
| <a name="input_detection_multiplier"></a> [detection\_multiplier](#input\_detection\_multiplier) | Detection multiplier. Minimum value: 1. Maximum value: 50. | `number` | `3` | no |
| <a name="input_echo_admin_state"></a> [echo\_admin\_state](#input\_echo\_admin\_state) | Echo admin state. | `bool` | `true` | no |
| <a name="input_echo_rx_interval"></a> [echo\_rx\_interval](#input\_echo\_rx\_interval) | Echo RX interval. Minimum value: 50. Maximum value: 999. | `number` | `50` | no |
| <a name="input_min_rx_interval"></a> [min\_rx\_interval](#input\_min\_rx\_interval) | Min RX interval. Minimum value: 50. Maximum value: 999. | `number` | `50` | no |
| <a name="input_min_tx_interval"></a> [min\_tx\_interval](#input\_min\_tx\_interval) | Min TX interval. Minimum value: 50. Maximum value: 999. | `number` | `50` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `bfdIfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | BFD interface policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.bfdIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->