<!-- BEGIN_TF_DOCS -->
# Terraform ACI ND Interface Policy Module

Manages ACI ND Interface Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `ND Interface`

## Examples

```hcl
module "aci_nd_interface_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-nd-interface-policy"
  version = ">= 0.8.1"

  tenant                   = "ABC"
  name                     = "ND-INTF-POL1"
  description              = "My Description"
  controller_state         = ["other-cfg"]
  hop_limit                = 32
  ns_tx_interval           = 1000
  mtu                      = 9000
  retransmit_retry_count   = 3
  nud_retransmit_base      = 1
  nud_retransmit_interval  = 2000
  nud_retransmit_count     = 3
  route_advertise_interval = 600
  router_lifetime          = 3600
  reachable_time           = 0
  retransmit_timer         = 0
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
| <a name="input_name"></a> [name](#input\_name) | ND interface policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_controller_state"></a> [controller\_state](#input\_controller\_state) | Controller administrative state. | `list(string)` | `[]` | no |
| <a name="input_hop_limit"></a> [hop\_limit](#input\_hop\_limit) | Detection multiplier. Minimum value: 0. Maximum value: 255. | `number` | `64` | no |
| <a name="input_ns_tx_interval"></a> [ns\_tx\_interval](#input\_ns\_tx\_interval) | Neighbor solicitation transmit interval (msec). Minimum value: 1000. Maximum value: 3600000. | `number` | `1000` | no |
| <a name="input_mtu"></a> [mtu](#input\_mtu) | Maximum transmission unit. Minimum value: 1280. Maximum value: 9000. | `number` | `9000` | no |
| <a name="input_retransmit_retry_count"></a> [retransmit\_retry\_count](#input\_retransmit\_retry\_count) | Retransmission retry count. Minimum value: 1. Maximum value: 100. | `number` | `3` | no |
| <a name="input_nud_retransmit_base"></a> [nud\_retransmit\_base](#input\_nud\_retransmit\_base) | NUD retransmission base. Minimum value: 1. Maximum value: 3. | `number` | `0` | no |
| <a name="input_nud_retransmit_interval"></a> [nud\_retransmit\_interval](#input\_nud\_retransmit\_interval) | NUD retransmission interval (msec). Minimum value: 1000. Maximum value: 10000. | `number` | `0` | no |
| <a name="input_nud_retransmit_count"></a> [nud\_retransmit\_count](#input\_nud\_retransmit\_count) | NUD retransmission count. Minimum value: 3. Maximum value: 10. | `number` | `0` | no |
| <a name="input_route_advertise_interval"></a> [route\_advertise\_interval](#input\_route\_advertise\_interval) | Route advertise interval. Minimum value: 4. Maximum value: 1800. | `number` | `600` | no |
| <a name="input_router_lifetime"></a> [router\_lifetime](#input\_router\_lifetime) | Router lifetime. Minimum value: 0. Maximum value: 9000. | `number` | `1800` | no |
| <a name="input_reachable_time"></a> [reachable\_time](#input\_reachable\_time) | Reachable time (msec). Minimum value: 0. Maximum value: 3600000. | `number` | `0` | no |
| <a name="input_retransmit_timer"></a> [retransmit\_timer](#input\_retransmit\_timer) | Retransmit timer (msec). Minimum value: 0. Maximum value: 4294967295. | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `ndIfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | ND interface policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.ndIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->