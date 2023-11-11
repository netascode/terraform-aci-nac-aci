<!-- BEGIN_TF_DOCS -->
# Terraform ACI Route Tag Policy Module

Description

Location in GUI:
`Tenants` » `Policies` » `Protocol` » `Route Tag`

## Examples

```hcl
module "aci_route_tag_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-route-tag-policy"
  version = ">= 0.8.0"

  tenant      = "TEN1"
  name        = "TAG1"
  description = "My Tag"
  tag         = 12345
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Route Tag Policy tenant's name. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Route Tag Policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Route Tag Policy description. | `string` | `""` | no |
| <a name="input_tag"></a> [tag](#input\_tag) | Route Tag. | `number` | `4294967295` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `l3extRouteTagPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Route Tag Policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.l3extRouteTagPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->