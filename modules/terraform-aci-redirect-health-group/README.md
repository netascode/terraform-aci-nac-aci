<!-- BEGIN_TF_DOCS -->
# Terraform ACI Redirect Health Group Module

Manages ACI Redirect Health Group

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `L4-L7 Redirect Health Groups`

## Examples

```hcl
module "redirect_health_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-redirect-health-group"
  version = ">= 0.8.0"

  name        = "ABC"
  tenant      = "TEN1"
  description = "My Description"
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
| <a name="input_name"></a> [name](#input\_name) | Redirect Health Group name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Redirect Health Group description. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vnsRedirectHealthGroup` object. |
| <a name="output_name"></a> [name](#output\_name) | Redirect Health Group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vnsRedirectHealthGroup](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->