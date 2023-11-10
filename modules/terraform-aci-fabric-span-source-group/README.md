<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-fabric-span-source-group/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-fabric-span-source-group/actions/workflows/test.yml)

# Terraform ACI Fabric SPAN Source Group Module

Manages ACI Fabric SPAN Source Group

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Troubleshooting` » `SPAN` » `SPAN Source Groups`

## Examples

```hcl
module "aci_fabric_span_source_group" {
  source      = "netascode/fabric-span-source-group/aci"
  version     = ">= 0.1.0"
  name        = "SPAN1"
  description = "My Test Fabric Span Source Group"
  admin_state = false
  sources = [
    {
      name        = "SRC1"
      description = "Source1"
      direction   = "both"
      span_drop   = "no"
      tenant      = "TEN1"
      vrf         = "VRF1"
      fabric_paths = [
        {
          node_id = 1001
          port    = 1
        }
      ]
    },
    {
      name          = "SRC2"
      description   = "Source2"
      direction     = "in"
      span_drop     = "no"
      tenant        = "TEN1"
      bridge_domain = "BD1"
      fabric_paths = [
        {
          node_id = 101
          port    = 49
        },
      ]
    }
  ]
  destination_name        = "DESTINATION1"
  destination_description = "My Destination"
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
| <a name="input_name"></a> [name](#input\_name) | SPAN source group name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | SPAN source group description. | `string` | `""` | no |
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | SPAN source group administrative state. | `bool` | `true` | no |
| <a name="input_sources"></a> [sources](#input\_sources) | List of SPAN sources. Choices `direction`: `in`, `both`, `out`. Default value `direction`: `both`. Default value `span_drop`: `false`. Allowed values `node_id`: `1` - `4000`. Allowed values `pod_id`: `1` - `255`. Default value `pod_id`: `1`. Allowed values `port`: `1` - `127`. Allowed values `module`: `1` - `9`. Default value `module`: `1`. | <pre>list(object({<br>    description   = optional(string, "")<br>    name          = string<br>    direction     = optional(string, "both")<br>    span_drop     = optional(bool, false)<br>    tenant        = optional(string)<br>    bridge_domain = optional(string)<br>    vrf           = optional(string)<br>    fabric_paths = optional(list(object({<br>      node_id = number<br>      pod_id  = optional(number, 1)<br>      port    = number<br>      module  = optional(number, 1)<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_destination_name"></a> [destination\_name](#input\_destination\_name) | SPAN source destination group name. | `string` | n/a | yes |
| <a name="input_destination_description"></a> [destination\_description](#input\_destination\_description) | SPAN source destination group description. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `spanSrcGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | SPAN Source Group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.spanRsSrcToBD](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToCtx](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToPathEp_port](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanSpanLbl](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanSrc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanSrcGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->