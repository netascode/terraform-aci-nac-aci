<!-- BEGIN_TF_DOCS -->
# Terraform ACI Tenant Module

Manages ACI Tenant

Location in GUI:
`Tenants`

## Examples

```hcl
module "aci_tenant" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tenant"
  version = ">= 0.8.0"

  name        = "ABC"
  alias       = "ABC-ALIAS"
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
| <a name="input_name"></a> [name](#input\_name) | Tenant name. | `string` | n/a | yes |
| <a name="input_annotation"></a> [annotation](#input\_annotation) | Annotation value. | `string` | `null` | no |
| <a name="input_alias"></a> [alias](#input\_alias) | Tenant alias. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Tenant description. | `string` | `""` | no |
| <a name="input_security_domains"></a> [security\_domains](#input\_security\_domains) | Security domains associated to tenant | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fvTenant` object. |
| <a name="output_name"></a> [name](#output\_name) | Tenant name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.aaaDomainRef](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fvTenant](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->