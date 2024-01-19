<!-- BEGIN_TF_DOCS -->
# Terraform ACI AAA Module

Manages ACI AAA configuration

Location in GUI:
`Admin` » `AAA` » `Authentication` » `AAA`

## Examples

```hcl
module "aci_aaa" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-aaa"
  version = ">= 0.8.0"

  remote_user_login_policy = "assign-default-role"
  default_fallback_check   = true
  default_realm            = "tacacs"
  default_login_domain     = "ISE"
  console_realm            = "tacacs"
  console_login_domain     = "ISE"
  password_strength_check  = true
  web_token_timeout        = 600
  web_token_max_validity   = 24
  web_session_idle_timeout = 1200
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
| <a name="input_remote_user_login_policy"></a> [remote\_user\_login\_policy](#input\_remote\_user\_login\_policy) | Remote user login policy. Choices: `assign-default-role`, `no-login` | `string` | `"no-login"` | no |
| <a name="input_default_fallback_check"></a> [default\_fallback\_check](#input\_default\_fallback\_check) | Default fallback check. | `bool` | `false` | no |
| <a name="input_default_realm"></a> [default\_realm](#input\_default\_realm) | Default realm. Choices: `local`, `tacacs`, `radius`. | `string` | `"local"` | no |
| <a name="input_default_login_domain"></a> [default\_login\_domain](#input\_default\_login\_domain) | Default login domain. | `string` | `""` | no |
| <a name="input_console_realm"></a> [console\_realm](#input\_console\_realm) | Console realm. Choices: `local`, `tacacs`, `radius`. | `string` | `"local"` | no |
| <a name="input_console_login_domain"></a> [console\_login\_domain](#input\_console\_login\_domain) | Console login domain. | `string` | `""` | no |
| <a name="input_security_domains"></a> [security\_domains](#input\_security\_domains) | List of security domains. | <pre>list(object({<br>    name                   = string<br>    description            = optional(string, "")<br>    restricted_rbac_domain = optional(bool, false)<br>  }))</pre> | `[]` | no |
| <a name="input_password_strength_check"></a> [password\_strength\_check](#input\_password\_strength\_check) | Password strength check. | `bool` | `false` | no |
| <a name="input_web_token_timeout"></a> [web\_token\_timeout](#input\_web\_token\_timeout) | Web session idle timeout (s). | `number` | `600` | no |
| <a name="input_web_token_max_validity"></a> [web\_token\_max\_validity](#input\_web\_token\_max\_validity) | Web token maximum validity period (h). | `number` | `24` | no |
| <a name="input_web_session_idle_timeout"></a> [web\_session\_idle\_timeout](#input\_web\_session\_idle\_timeout) | Web session idle timeout (s). | `number` | `1200` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `aaaAuthRealm` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.aaaAuthRealm](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaConsoleAuth](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaDefaultAuth](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaDomain](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaUserEp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pkiWebTokenData](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->