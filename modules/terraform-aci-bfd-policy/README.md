<!-- BEGIN_TF_DOCS -->
# Terraform ACI BFD Switch Policy Module

Manages ACI BFD Switch Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Switch` » `BFD`

## Examples

```hcl
module "aci_bfd_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bfd-policy"
  version = ">= 0.8.0"

  name                   = "BFD-IPV4-POLICY"
  type                   = "ipv4"
  description            = "BFD IPv4 Policy"
  detection_multiplier   = 3
  min_rx_interval        = 50
  min_tx_interval        = 50
  slow_timer_interval    = 2000
  startup_timer_interval = 10
  echo_rx_interval       = 50
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
| <a name="input_name"></a> [name](#input\_name) | BFD policy name. | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | BFD policy type. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | BFD policy description. | `string` | `""` | no |
| <a name="input_detection_multiplier"></a> [detection\_multiplier](#input\_detection\_multiplier) | Detection multiplier. Minimum value: 1. Maximum value: 50. | `number` | `3` | no |
| <a name="input_min_rx_interval"></a> [min\_rx\_interval](#input\_min\_rx\_interval) | Min RX interval. Minimum value: 50. Maximum value: 999. | `number` | `50` | no |
| <a name="input_min_tx_interval"></a> [min\_tx\_interval](#input\_min\_tx\_interval) | Min TX interval. Minimum value: 50. Maximum value: 999. | `number` | `50` | no |
| <a name="input_slow_timer_interval"></a> [slow\_timer\_interval](#input\_slow\_timer\_interval) | Slow timer interval. Minimum value: 1000. Maximum value: 30000. | `number` | `2000` | no |
| <a name="input_startup_timer_interval"></a> [startup\_timer\_interval](#input\_startup\_timer\_interval) | Startup timer interval. Minimum value: 0. Maximum value: 60. | `number` | `null` | no |
| <a name="input_echo_rx_interval"></a> [echo\_rx\_interval](#input\_echo\_rx\_interval) | Echo rx interval. Minimum value: 0. Maximum value: 999. | `number` | `50` | no |
| <a name="input_echo_frame_source_address"></a> [echo\_frame\_source\_address](#input\_echo\_frame\_source\_address) | BFD Source Address for Echo frames. | `string` | `"0.0.0.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `bfdInstPol` object. |
| <a name="output_name"></a> [name](#output\_name) | BFD Policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.bfdInstPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->