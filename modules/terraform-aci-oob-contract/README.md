<!-- BEGIN_TF_DOCS -->
# Terraform ACI OOB Contract Module

Manages ACI OOB Contract

Location in GUI:
`Tenants` » `mgmt` » `Contracts` » `Out-Of-Band Contracts`

## Examples

```hcl
module "aci_oob_contract" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-oob-contract"
  version = ">= 0.8.0"

  name        = "OOB1"
  alias       = "OOB1-ALIAS"
  description = "My Description"
  scope       = "global"
  subjects = [{
    name        = "SUB1"
    alias       = "SUB1-ALIAS"
    description = "Subject Description"
    filters = [{
      filter = "FILTER1"
    }]
  }]
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
| <a name="input_name"></a> [name](#input\_name) | OOB Contract name. | `string` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | Alias. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | Scope. Choices: `application-profile`, `tenant`, `context`, `global`. | `string` | `"context"` | no |
| <a name="input_subjects"></a> [subjects](#input\_subjects) | List of subjects. | <pre>list(object({<br/>    name        = string<br/>    alias       = optional(string, "")<br/>    description = optional(string, "")<br/>    filters = list(object({<br/>      filter = string<br/>    }))<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vzOOBBrCP` object. |
| <a name="output_name"></a> [name](#output\_name) | OOB contract name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vzOOBBrCP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsSubjFiltAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzSubj](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->