<!-- BEGIN_TF_DOCS -->
# Terraform ACI Set Rule Module

Manages ACI Set Rule

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `Set Rules`

## Examples

```hcl
module "aci_set_rule" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-set-rule"
  version = ">= 0.8.0"

  tenant                      = "ABC"
  name                        = "SR1"
  description                 = "My Description"
  community                   = "no-export"
  community_mode              = "replace"
  dampening                   = true
  dampening_half_life         = 15
  dampening_max_suppress_time = 60
  dampening_reuse_limit       = 750
  dampening_suppress_limit    = 2000
  weight                      = 100
  next_hop                    = "1.1.1.1"
  metric                      = 1
  preference                  = 1
  metric_type                 = "ospf-type1"
  additional_communities = [
    {
      community   = "regular:as2-nn2:4:15"
      description = "My Community"
    }
  ]
  set_as_paths = [
    {
      criteria = "prepend"
      asns = [
        {
          number = 65001
          order  = 5
        }
      ]
    }
  ]
  next_hop_propagation = true
  multipath            = true
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Set rule name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_community"></a> [community](#input\_community) | Community. | `string` | `""` | no |
| <a name="input_community_mode"></a> [community\_mode](#input\_community\_mode) | Community mode. Choices: `append`, `replace`. | `string` | `"append"` | no |
| <a name="input_tag"></a> [tag](#input\_tag) | Tag. Allowed values `tag`: 0-4294967295. | `number` | `null` | no |
| <a name="input_dampening"></a> [dampening](#input\_dampening) | Dampening. | `bool` | `false` | no |
| <a name="input_dampening_half_life"></a> [dampening\_half\_life](#input\_dampening\_half\_life) | Dampening Half Life. Allowed values `dampening_half_life`: `1-60`. | `number` | `15` | no |
| <a name="input_dampening_max_suppress_time"></a> [dampening\_max\_suppress\_time](#input\_dampening\_max\_suppress\_time) | Dampening Max Supress. Allowed values `dampening_max_suppress_time`: `1-255`. | `number` | `60` | no |
| <a name="input_dampening_reuse_limit"></a> [dampening\_reuse\_limit](#input\_dampening\_reuse\_limit) | Dampening Re-use Limit. Allowed values `dampening_reuse_limit`: `1-2000`. | `number` | `750` | no |
| <a name="input_dampening_suppress_limit"></a> [dampening\_suppress\_limit](#input\_dampening\_suppress\_limit) | Dampening Supress Limit. Allowed values `dampening_suppress_limit`: `1-2000`. | `number` | `2000` | no |
| <a name="input_weight"></a> [weight](#input\_weight) | Weight. Allowed values `weight`: 0-65535. | `number` | `null` | no |
| <a name="input_next_hop"></a> [next\_hop](#input\_next\_hop) | Next Hop IP. | `string` | `""` | no |
| <a name="input_preference"></a> [preference](#input\_preference) | Preference. Allowed values `preference`: 0-4294967295. | `number` | `null` | no |
| <a name="input_metric"></a> [metric](#input\_metric) | Metric. Allowed values `metric`: 0-4294967295. | `number` | `null` | no |
| <a name="input_metric_type"></a> [metric\_type](#input\_metric\_type) | Metric Type. Choice `metric_type`: `ospf-type1` or `ospf-type1`. | `string` | `""` | no |
| <a name="input_additional_communities"></a> [additional\_communities](#input\_additional\_communities) | Additional communities. | <pre>list(object({<br/>    community   = string<br/>    description = optional(string, "")<br/>  }))</pre> | `[]` | no |
| <a name="input_set_as_paths"></a> [set\_as\_paths](#input\_set\_as\_paths) | AS-Path Set List. | <pre>list(object({<br/>    criteria = optional(string, "prepend")<br/>    count    = optional(number, 1)<br/>    asns = list(object({<br/>      order      = optional(number, 0)<br/>      asn_number = number<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_next_hop_propagation"></a> [next\_hop\_propagation](#input\_next\_hop\_propagation) | Next Hop Propagation. | `bool` | `false` | no |
| <a name="input_multipath"></a> [multipath](#input\_multipath) | Multipath. | `bool` | `false` | no |
| <a name="input_external_endpoint_group"></a> [external\_endpoint\_group](#input\_external\_endpoint\_group) | External endpoint group name. | `string` | `""` | no |
| <a name="input_external_endpoint_group_l3out"></a> [external\_endpoint\_group\_l3out](#input\_external\_endpoint\_group\_l3out) | External endpoint group l3out name. | `string` | `""` | no |
| <a name="input_external_endpoint_group_tenant"></a> [external\_endpoint\_group\_tenant](#input\_external\_endpoint\_group\_tenant) | External endpoint group tenant name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `rtctrlAttrP` object. |
| <a name="output_name"></a> [name](#output\_name) | Set rule name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.rtctrlAttrP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlRsSetPolicyTagToInstP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSetASPath](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSetASPathASN](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSetAddComm](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSetComm](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSetDamp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSetNh](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSetNhUnchanged](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSetPolicyTag](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSetPref](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSetRedistMultipath](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSetRtMetric](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSetRtMetricType](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSetTag](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSetWeight](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->