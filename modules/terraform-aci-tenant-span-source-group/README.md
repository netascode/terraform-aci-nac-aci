<!-- BEGIN_TF_DOCS -->
#  Terraform ACI Tenant SPAN Source Group Module

Manages ACI Tenant SPAN Source Group

Location in GUI:
`Tenants` » `Policies` » `Troubleshooting` » `SPAN` » `SPAN Source Groups`

## Examples

```hcl
module "aci_tenant_span_source_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tenant-span-source-group"
  version = ">= 0.8.0"

  name        = "SPAN1"
  tenant      = "ABC"
  description = "My Test Tenant Span Source Group"
  admin_state = false
  sources = [
    {
      name                = "SRC1"
      description         = "Source1"
      direction           = "both"
      endpoint_group      = "EPG1"
      application_profile = "AP1"
    }
  ]
  destination = "DESTINATION1"
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
| <a name="input_name"></a> [name](#input\_name) | SPAN source group name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | SPAN source group description. | `string` | `""` | no |
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | SPAN source group administrative state. | `bool` | `true` | no |
| <a name="input_destination"></a> [destination](#input\_destination) | SPAN source destination group name. | `string` | n/a | yes |
| <a name="input_sources"></a> [sources](#input\_sources) | List of SPAN sources. Choices `direction`: `in`, `both`, `out`. Default value `direction`: `both`. | <pre>list(object({<br/>    name                = string<br/>    description         = optional(string, "")<br/>    direction           = optional(string, "both")<br/>    application_profile = optional(string)<br/>    endpoint_group      = optional(string)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `spanSrcGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | SPAN Source Group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.spanRsSrcToEpg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanSpanLbl](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanSrc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanSrcGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->