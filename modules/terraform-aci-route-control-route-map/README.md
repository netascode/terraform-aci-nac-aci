<!-- BEGIN_TF_DOCS -->
# Terraform ACI Route Control Route Map Module

Manages ACI Route Control Route Maps

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `Route Maps for Route Control`

## Examples

```hcl
module "aci_route_control_route_map" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-route-control-route-map"
  version = ">= 0.8.0"

  name        = "ABC"
  description = "My Description"
  type        = "combinable"
  tenant      = "TEN1"
  contexts = [
    {
      name        = "CTX1"
      description = "My Context 1"
      action      = "deny"
      order       = 1
      set_rule    = "SET1"
      match_rules = ["MATCH1"]
    },
    {
      name        = "CTX2"
      match_rules = ["MATCH2", "MATCH3"]
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Route Control Route Map name. | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Route Control Route Map type. | `string` | `"combinable"` | no |
| <a name="input_description"></a> [description](#input\_description) | Route Control Route Map description. | `string` | `""` | no |
| <a name="input_contexts"></a> [contexts](#input\_contexts) | Route Control Route Map contexts. Allowed values `action`:  `deny` or `permit`. Allowed values `order`: 0-9. | <pre>list(object({<br/>    name        = string<br/>    description = optional(string, "")<br/>    action      = optional(string, "permit")<br/>    order       = optional(number, 0)<br/>    set_rule    = optional(string, "")<br/>    match_rules = optional(list(string), [])<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `rtctrlProfile` object. |
| <a name="output_name"></a> [name](#output\_name) | Route Map name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.rtctrlCtxP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlProfile](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlRsCtxPToSubjP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlRsScopeToAttrP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlScope](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->