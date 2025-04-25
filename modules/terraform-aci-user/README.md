<!-- BEGIN_TF_DOCS -->
# Terraform ACI User Module

Manages ACI User

Location in GUI:
`Admin` » `AAA` » `Users` » `Local Users`

## Examples

```hcl
module "aci_user" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-user"
  version = ">= 0.8.0"

  username         = "USER1"
  password         = "PASSWORD1"
  status           = "inactive"
  certificate_name = "CERT1"
  description      = "My Description"
  email            = "aa.aa@aa.aa"
  expires          = true
  expire_date      = "2031-01-20T10:00:00.000+00:00"
  first_name       = "First"
  last_name        = "Last"
  phone            = "1234567"
  domains = [{
    name = "all"
    roles = [{
      name           = "admin"
      privilege_type = "write"
    }]
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.15.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_username"></a> [username](#input\_username) | Username. | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Password. | `string` | n/a | yes |
| <a name="input_status"></a> [status](#input\_status) | Status. Choices: `active`, `inactive`, `blocked`. | `string` | `"active"` | no |
| <a name="input_certificate_name"></a> [certificate\_name](#input\_certificate\_name) | Certificate name. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_email"></a> [email](#input\_email) | Email | `string` | `""` | no |
| <a name="input_expires"></a> [expires](#input\_expires) | Expires. | `bool` | `false` | no |
| <a name="input_expire_date"></a> [expire\_date](#input\_expire\_date) | Expire date. Allowed values are `never` or timestamp like `2021-01-20T10:00:00.000+00:00`. | `string` | `"never"` | no |
| <a name="input_first_name"></a> [first\_name](#input\_first\_name) | First name. | `string` | `""` | no |
| <a name="input_last_name"></a> [last\_name](#input\_last\_name) | Last name. | `string` | `""` | no |
| <a name="input_phone"></a> [phone](#input\_phone) | Phone. | `string` | `""` | no |
| <a name="input_domains"></a> [domains](#input\_domains) | List of domains. Choices `privilege_type`: `write`, `read`. Default value `privilege_type`: `read`. | <pre>list(object({<br/>    name = string<br/>    roles = optional(list(object({<br/>      name           = string<br/>      privilege_type = optional(string, "read")<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | List of certificates. | <pre>list(object({<br/>    name = string<br/>    data = string<br/>  }))</pre> | `[]` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | List of SSH keys. | <pre>list(object({<br/>    name = string<br/>    data = string<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `aaaUser` object. |
| <a name="output_username"></a> [username](#output\_username) | Username. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.aaaSshAuth](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaUser](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaUserCert](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaUserDomain](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaUserRole](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->