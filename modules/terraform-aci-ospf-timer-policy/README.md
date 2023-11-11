<!-- BEGIN_TF_DOCS -->
# Terraform ACI OSPF Timer Policy Module

Manages ACI OSPF Timer Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `OSPF` » `OSPF Timers`

## Examples

```hcl
module "aci_ospf_timer_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-ospf-timer-policy"
  version = ">= 0.8.0"

  tenant                    = "ABC"
  name                      = "OSPFT1"
  description               = "My Description"
  reference_bandwidth       = 10000
  distance                  = 105
  max_ecmp                  = 4
  spf_init_interval         = 100
  spf_hold_interval         = 500
  spf_max_interval          = 2500
  max_lsa_reset_interval    = 20
  max_lsa_sleep_count       = 10
  max_lsa_sleep_interval    = 10
  lsa_arrival_interval      = 500
  lsa_group_pacing_interval = 20
  lsa_hold_interval         = 2500
  lsa_start_interval        = 10
  lsa_max_interval          = 2500
  max_lsa_num               = 40000
  max_lsa_threshold         = 100
  max_lsa_action            = "log"
  graceful_restart          = true
  router_id_lookup          = true
  prefix_suppression        = true
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
| <a name="input_name"></a> [name](#input\_name) | OSPF timer policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_reference_bandwidth"></a> [reference\_bandwidth](#input\_reference\_bandwidth) | Reference bandwidth. Minimum value: `1`. Maximum value: `4000000`. | `number` | `40000` | no |
| <a name="input_distance"></a> [distance](#input\_distance) | Distance. Minimum value: `1`. Maximum value: `255`. | `number` | `110` | no |
| <a name="input_max_ecmp"></a> [max\_ecmp](#input\_max\_ecmp) | Max ECMP. Minimum value: `1`. Maximum value: `64`. | `number` | `8` | no |
| <a name="input_spf_init_interval"></a> [spf\_init\_interval](#input\_spf\_init\_interval) | SPF init interval. Minimum value: `1`. Maximum value: `600000`. | `number` | `200` | no |
| <a name="input_spf_hold_interval"></a> [spf\_hold\_interval](#input\_spf\_hold\_interval) | SPF hold interval. Minimum value: `1`. Maximum value: `600000`. | `number` | `1000` | no |
| <a name="input_spf_max_interval"></a> [spf\_max\_interval](#input\_spf\_max\_interval) | SPF max interval. Minimum value: `1`. Maximum value: `600000`. | `number` | `5000` | no |
| <a name="input_max_lsa_reset_interval"></a> [max\_lsa\_reset\_interval](#input\_max\_lsa\_reset\_interval) | Max LSA reset interval. Minimum value: `1`. Maximum value: `1440`. | `number` | `10` | no |
| <a name="input_max_lsa_sleep_count"></a> [max\_lsa\_sleep\_count](#input\_max\_lsa\_sleep\_count) | Max LSA sleep count. Minimum value: `1`. Maximum value: `4294967295`. | `number` | `5` | no |
| <a name="input_max_lsa_sleep_interval"></a> [max\_lsa\_sleep\_interval](#input\_max\_lsa\_sleep\_interval) | Max LSA sleep interval. Minimum value: `1`. Maximum value: `1440`. | `number` | `5` | no |
| <a name="input_lsa_arrival_interval"></a> [lsa\_arrival\_interval](#input\_lsa\_arrival\_interval) | LSA arrival interval. Minimum value: `10`. Maximum value: `600000`. | `number` | `1000` | no |
| <a name="input_lsa_group_pacing_interval"></a> [lsa\_group\_pacing\_interval](#input\_lsa\_group\_pacing\_interval) | LSA group pacing interval. Minimum value: `1`. Maximum value: `1800`. | `number` | `10` | no |
| <a name="input_lsa_hold_interval"></a> [lsa\_hold\_interval](#input\_lsa\_hold\_interval) | LSA hold interval. Minimum value: `50`. Maximum value: `30000`. | `number` | `5000` | no |
| <a name="input_lsa_start_interval"></a> [lsa\_start\_interval](#input\_lsa\_start\_interval) | LSA start interval. Minimum value: `0`. Maximum value: `5000`. | `number` | `0` | no |
| <a name="input_lsa_max_interval"></a> [lsa\_max\_interval](#input\_lsa\_max\_interval) | LSA max interval. Minimum value: `50`. Maximum value: `30000`. | `number` | `5000` | no |
| <a name="input_max_lsa_num"></a> [max\_lsa\_num](#input\_max\_lsa\_num) | Max LSA number. | `number` | `20000` | no |
| <a name="input_max_lsa_threshold"></a> [max\_lsa\_threshold](#input\_max\_lsa\_threshold) | Max LSA threshold. Minimum value: `1`. Maximum value: `100`. | `number` | `75` | no |
| <a name="input_max_lsa_action"></a> [max\_lsa\_action](#input\_max\_lsa\_action) | Max LSA action. Choices: `reject`, `log`. | `string` | `"reject"` | no |
| <a name="input_graceful_restart"></a> [graceful\_restart](#input\_graceful\_restart) | Graceful restart. | `bool` | `false` | no |
| <a name="input_router_id_lookup"></a> [router\_id\_lookup](#input\_router\_id\_lookup) | Router ID lookup. | `bool` | `false` | no |
| <a name="input_prefix_suppression"></a> [prefix\_suppression](#input\_prefix\_suppression) | Prefix suppression. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `ospfCtxPol` object. |
| <a name="output_name"></a> [name](#output\_name) | OSPF timer policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.ospfCtxPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->