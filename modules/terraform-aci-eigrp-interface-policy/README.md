<!-- BEGIN_TF_DOCS -->
# Terraform ACI EIGRP Interface Policy Module

Manages ACI EIGRP Interface Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `EIGRP` » `EIGRP Interface`

## Examples

```hcl
module "aci_eigrp_interface_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-eigrp-interface-policy"
  version = ">= 0.8.0"

  tenant            = "TF"
  name              = "EIGRP1"
  description       = "My Description"
  hello_interval    = 10
  hold_interval     = 30
  bandwidth         = 10
  delay             = 20
  delay_unit        = "pico"
  bfd               = true
  self_nexthop      = true
  passive_interface = true
  split_horizon     = true
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
| <a name="input_name"></a> [name](#input\_name) | EIGRP interface policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_hold_interval"></a> [hold\_interval](#input\_hold\_interval) | Hold interval. Minimum value: `1`. Maximum value: `65535`. | `number` | `15` | no |
| <a name="input_hello_interval"></a> [hello\_interval](#input\_hello\_interval) | Hello interval. Minimum value: `1`. Maximum value: `65535`. | `number` | `5` | no |
| <a name="input_bandwidth"></a> [bandwidth](#input\_bandwidth) | Bandwidth. Minimum value: `0`. Maximum value: `256000000`. | `number` | `1` | no |
| <a name="input_delay"></a> [delay](#input\_delay) | Delay. Minimum value: `0`. Maximum value: `4294967295`. | `number` | `1` | no |
| <a name="input_delay_unit"></a> [delay\_unit](#input\_delay\_unit) | Delay Unit. Choices: `tens-of-micro`, `pico`. | `string` | `"tens-of-micro"` | no |
| <a name="input_bfd"></a> [bfd](#input\_bfd) | BFD. | `bool` | `false` | no |
| <a name="input_self_nexthop"></a> [self\_nexthop](#input\_self\_nexthop) | Self Nexthop. | `bool` | `true` | no |
| <a name="input_passive_interface"></a> [passive\_interface](#input\_passive\_interface) | Passive interface. | `bool` | `false` | no |
| <a name="input_split_horizon"></a> [split\_horizon](#input\_split\_horizon) | Split Horizon. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `eigrpIfPol` object. |
| <a name="output_name"></a> [name](#output\_name) | EIGRP interface policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.eigrpIfPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->