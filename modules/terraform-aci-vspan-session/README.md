<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-vspan-session/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-vspan-session/actions/workflows/test.yml)

# Terraform ACI VSPAN Session Module

Manages ACI VSPAN Session

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Troubleshooting` » `VSPAN` » `VSPAN Sessions`

## Examples

```hcl
module "aci_access_vspan_session" {
  source  = "netascode/vspan-session/aci"
  version = ">= 0.1.0"

  name                    = "SESSION1"
  description             = "VSPAN Session 1"
  admin_state             = true
  destination_name        = "DST_GRP1"
  destination_description = "Destination Group 1"
  sources = [
    {
      description         = "Source 1"
      name                = "SRC1"
      direction           = "both"
      tenant              = "TENANT-1"
      application_profile = "AP1"
      endpoint_group      = "EGP1"
      endpoint            = "00:50:56:96:6B:4F"
      access_paths = [
        {
          node_id = 101
          port    = 3
        },
        {
          node_id = 101
          port    = 1
        }
      ]
    },
    {
      description         = "Source 2"
      name                = "SRC2"
      direction           = "in"
      tenant              = "TENANT-2"
      application_profile = "AP1"
      endpoint_group      = "EGP1"
      access_paths = [
        {
          node_id = 101
          port    = 1
        },
        {
          node_id  = 101
          node2_id = 102
          channel  = VPC1
        },
        {
          node_id = 101
          channel = PC1
        }
      ]
    }
  ]
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
| <a name="input_name"></a> [name](#input\_name) | VSPAN session name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | VSPAN session description. | `string` | `""` | no |
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | VSPAN session administrative state. | `bool` | `true` | no |
| <a name="input_destination_name"></a> [destination\_name](#input\_destination\_name) | VSPAN session destination group name. | `string` | n/a | yes |
| <a name="input_destination_description"></a> [destination\_description](#input\_destination\_description) | VSPAN session destination group description. | `string` | `""` | no |
| <a name="input_sources"></a> [sources](#input\_sources) | List of VSPAN session sources. Allowed values `direction`: `in`, `out`, `both`. | <pre>list(object({<br>    description         = optional(string, "")<br>    name                = string<br>    direction           = optional(string, "both")<br>    tenant              = optional(string)<br>    application_profile = optional(string)<br>    endpoint_group      = optional(string)<br>    endpoint            = optional(string)<br>    access_paths = optional(list(object({<br>      node_id  = number<br>      node2_id = optional(number)<br>      fex_id   = optional(number)<br>      fex2_id  = optional(number)<br>      pod_id   = optional(number, 1)<br>      port     = optional(number)<br>      sub_port = optional(number)<br>      module   = optional(number, 1)<br>      channel  = optional(string)<br>    })), [])<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `spanVSrcGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | VSPAN session name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.spanRsSrcToEpg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToPathEp_channel](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToPathEp_fex_channel](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToPathEp_fex_port](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToPathEp_port](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToPathEp_subport](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToVPort](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanSpanLbl](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanVSrc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanVSrcGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->