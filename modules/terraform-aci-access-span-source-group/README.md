<!-- BEGIN_TF_DOCS -->
# Terraform ACI Access SPAN Source Group Module

Manages ACI Access SPAN Source Group

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Troubleshooting` » `SPAN` » `SPAN Source Groups`

## Examples

```hcl
module "aci-access-span-source-group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-span-source-group"
  version = ">= 0.8.0"

  name        = "SPAN1"
  description = "My Test Span Group"
  admin_state = false
  sources = [
    {
      name                = "SRC1"
      description         = "Source1"
      direction           = "both"
      span_drop           = "no"
      tenant              = "TEN1"
      application_profile = "APP1"
      endpoint_group      = "EPG1"
      access_paths = [
        {
          node_id = 1001
          port    = 11
        },
        {
          node_id  = 101
          node2_id = 102
          fex_id   = 151
          fex2_id  = 152
          channel  = "ipg_vpc_test"
        },
        {
          node_id = 101
          fex_id  = 151
          channel = "ipg_regular-po_test"
        },
        {
          node_id = 101
          fex_id  = 151
          port    = 1
        }
      ]
    },
  ]
  filter_group = "FILTER1"
  destination = {
    name        = "DESTINATION1"
    description = "My Destination"
  }
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
| <a name="input_name"></a> [name](#input\_name) | SPAN Source Group name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | SPAN Source Group description. | `string` | `""` | no |
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | SPAN Source Group Administrative state. | `bool` | `true` | no |
| <a name="input_sources"></a> [sources](#input\_sources) | List of SPAN sources. Choices `direction`: `in`, `both`, `out`. Default value `direction`: `both`. Choices `span_drop`: `false`, `true`. Default value `span_drop`: `false`. List of Access Paths `access_paths`. Allowed values `node_id`, `node2_id`: `1` - `4000`. Allowed values `fex_id`, `fex2_id`: `101` - `199`. Allowed values `vlan`: `1` - `4096`. Allowed values `pod_id`: `1` - `255`. Default value `pod_id`: `1`. Allowed values `port`: `1` - `127`. Allowed values `sub_port`: `1` - `16`. Allowed values `module`: `1` - `9`. Default value `module`: `1`. | <pre>list(object({<br/>    description         = optional(string, "")<br/>    name                = string<br/>    direction           = optional(string, "both")<br/>    span_drop           = optional(bool, false)<br/>    tenant              = optional(string)<br/>    application_profile = optional(string)<br/>    endpoint_group      = optional(string)<br/>    l3out               = optional(string)<br/>    vlan                = optional(number)<br/>    access_paths = optional(list(object({<br/>      node_id  = number<br/>      node2_id = optional(number)<br/>      fex_id   = optional(number)<br/>      fex2_id  = optional(number)<br/>      pod_id   = optional(number, 1)<br/>      port     = optional(number)<br/>      sub_port = optional(number)<br/>      module   = optional(number, 1)<br/>      channel  = optional(string)<br/>      type     = optional(string)<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_filter_group"></a> [filter\_group](#input\_filter\_group) | SPAN Source Filter Group. | `string` | `""` | no |
| <a name="input_destination_name"></a> [destination\_name](#input\_destination\_name) | SPAN Source Destination Group Name. | `string` | n/a | yes |
| <a name="input_destination_description"></a> [destination\_description](#input\_destination\_description) | SPAN Source Destination Group Description. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `spanSrcGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | SPAN Source Group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.spanRsSrcGrpToFilterGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToEpg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToL3extOut](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToPathEp_channel](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToPathEp_fex_channel](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToPathEp_fex_port](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToPathEp_port](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToPathEp_subport](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanSpanLbl](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanSrc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanSrcGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->