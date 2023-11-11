<!-- BEGIN_TF_DOCS -->
# Terraform ACI OSPF Interface Policy Module

Manages ACI OSPF Interface Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `OSPF` » `OSPF Interface`

## Examples

```hcl
module "aci_ospf_interface_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-ospf-interface-policy"
  version = ">= 0.8.0"

  tenant                  = "ABC"
  name                    = "OSPF1"
  description             = "My Description"
  cost                    = "10"
  dead_interval           = 50
  hello_interval          = 15
  network_type            = "p2p"
  priority                = 10
  lsa_retransmit_interval = 10
  lsa_transmit_delay      = 3
  passive_interface       = true
  mtu_ignore              = true
  advertise_subnet        = true
  bfd                     = true
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
| <a name="input_name"></a> [name](#input\_name) | OSPF interface policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_cost"></a> [cost](#input\_cost) | Interface cost. Allowed values are `unspecified` or a number between 0 and 65535. | `string` | `"unspecified"` | no |
| <a name="input_dead_interval"></a> [dead\_interval](#input\_dead\_interval) | Dead interval. Minimum value: `1`. Maximum value: `65535`. | `number` | `40` | no |
| <a name="input_hello_interval"></a> [hello\_interval](#input\_hello\_interval) | Hello interval. Minimum value: `1`. Maximum value: `65535`. | `number` | `10` | no |
| <a name="input_network_type"></a> [network\_type](#input\_network\_type) | Network type. Choices: `bcast`, `p2p`. | `string` | `"bcast"` | no |
| <a name="input_priority"></a> [priority](#input\_priority) | Priority. Minimum value: `0`. Maximum value: `255`. | `number` | `1` | no |
| <a name="input_lsa_retransmit_interval"></a> [lsa\_retransmit\_interval](#input\_lsa\_retransmit\_interval) | LSA retransmit interval. Minimum value: `1`. Maximum value: `65535`. | `number` | `5` | no |
| <a name="input_lsa_transmit_delay"></a> [lsa\_transmit\_delay](#input\_lsa\_transmit\_delay) | LSA transmit delay. Minimum value: `1`. Maximum value: `450`. | `number` | `1` | no |
| <a name="input_passive_interface"></a> [passive\_interface](#input\_passive\_interface) | Passive interface. | `bool` | `false` | no |
| <a name="input_mtu_ignore"></a> [mtu\_ignore](#input\_mtu\_ignore) | MTU ignore. | `bool` | `false` | no |
| <a name="input_advertise_subnet"></a> [advertise\_subnet](#input\_advertise\_subnet) | Advertise subnet. | `bool` | `false` | no |
| <a name="input_bfd"></a> [bfd](#input\_bfd) | BFD. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `ospfIfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | OSPF interface policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.ospfIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->