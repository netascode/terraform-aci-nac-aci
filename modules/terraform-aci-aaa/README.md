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

  remote_user_login_policy         = "assign-default-role"
  default_fallback_check           = true
  default_realm                    = "tacacs"
  default_login_domain             = "ISE"
  console_realm                    = "tacacs"
  console_login_domain             = "ISE"
  password_strength_check          = true
  min_password_length              = 8
  max_password_length              = 64
  password_strength_test_type      = "custom"
  password_class_flags             = ["digits", "lowercase", "specialchars", "uppercase"]
  password_change_during_interval  = true
  password_change_interval         = 72
  password_change_count            = 3
  password_history_count           = 6
  password_no_change_interval      = 24
  web_token_timeout                = 600
  web_token_max_validity           = 24
  web_session_idle_timeout         = 1200
  include_refresh_session_records  = true
  enable_login_block               = true
  login_block_duration             = 60
  login_max_failed_attempts        = 5
  login_max_failed_attempts_window = 5
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
| <a name="input_default_realm"></a> [default\_realm](#input\_default\_realm) | Default realm. Choices: `local`, `tacacs`, `radius`, `ldap`. | `string` | `"local"` | no |
| <a name="input_default_login_domain"></a> [default\_login\_domain](#input\_default\_login\_domain) | Default login domain. | `string` | `""` | no |
| <a name="input_console_realm"></a> [console\_realm](#input\_console\_realm) | Console realm. Choices: `local`, `tacacs`, `radius`, `ldap`. | `string` | `"local"` | no |
| <a name="input_console_login_domain"></a> [console\_login\_domain](#input\_console\_login\_domain) | Console login domain. | `string` | `""` | no |
| <a name="input_security_domains"></a> [security\_domains](#input\_security\_domains) | List of security domains. | <pre>list(object({<br/>    name                   = string<br/>    description            = optional(string, "")<br/>    restricted_rbac_domain = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_password_strength_check"></a> [password\_strength\_check](#input\_password\_strength\_check) | Password strength check. | `bool` | `false` | no |
| <a name="input_min_password_length"></a> [min\_password\_length](#input\_min\_password\_length) | Minimum password length. | `number` | `8` | no |
| <a name="input_max_password_length"></a> [max\_password\_length](#input\_max\_password\_length) | Maximum password length. | `number` | `64` | no |
| <a name="input_password_strength_test_type"></a> [password\_strength\_test\_type](#input\_password\_strength\_test\_type) | Password strength test type for Password Strength Policy | `string` | `"default"` | no |
| <a name="input_password_class_flags"></a> [password\_class\_flags](#input\_password\_class\_flags) | Password class flags for Password Strength Policy | `list(string)` | <pre>[<br/>  "digits",<br/>  "lowercase",<br/>  "uppercase"<br/>]</pre> | no |
| <a name="input_password_change_during_interval"></a> [password\_change\_during\_interval](#input\_password\_change\_during\_interval) | Enables or disables password change during interval. | `bool` | `true` | no |
| <a name="input_password_change_count"></a> [password\_change\_count](#input\_password\_change\_count) | The number of password changes allowed within the change interval. | `number` | `2` | no |
| <a name="input_password_change_interval"></a> [password\_change\_interval](#input\_password\_change\_interval) | A time interval (hours) for limiting the number of password changes. | `number` | `48` | no |
| <a name="input_password_no_change_interval"></a> [password\_no\_change\_interval](#input\_password\_no\_change\_interval) | A minimum period after a password change before the user can change the password again. | `number` | `24` | no |
| <a name="input_password_history_count"></a> [password\_history\_count](#input\_password\_history\_count) | Number of recent user passwords to store. | `number` | `5` | no |
| <a name="input_web_token_timeout"></a> [web\_token\_timeout](#input\_web\_token\_timeout) | Web session idle timeout (s). | `number` | `600` | no |
| <a name="input_web_token_max_validity"></a> [web\_token\_max\_validity](#input\_web\_token\_max\_validity) | Web token maximum validity period (h). | `number` | `24` | no |
| <a name="input_web_session_idle_timeout"></a> [web\_session\_idle\_timeout](#input\_web\_session\_idle\_timeout) | Web session idle timeout (s). | `number` | `1200` | no |
| <a name="input_include_refresh_session_records"></a> [include\_refresh\_session\_records](#input\_include\_refresh\_session\_records) | Enables or disables inluding a refresh in the session records. | `bool` | `true` | no |
| <a name="input_enable_login_block"></a> [enable\_login\_block](#input\_enable\_login\_block) | Enables or disables lockout user after multiple failed login attempts. | `bool` | `false` | no |
| <a name="input_login_block_duration"></a> [login\_block\_duration](#input\_login\_block\_duration) | Duration in minutes for which future logins should be blocked. | `number` | `60` | no |
| <a name="input_login_max_failed_attempts"></a> [login\_max\_failed\_attempts](#input\_login\_max\_failed\_attempts) | Max failed login attempts before blocking user login. | `number` | `5` | no |
| <a name="input_login_max_failed_attempts_window"></a> [login\_max\_failed\_attempts\_window](#input\_login\_max\_failed\_attempts\_window) | Time period (unit: minute) in which consecutive attempts were failed. | `number` | `5` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `aaaAuthRealm` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.aaaAuthRealm](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaBlockLoginProfile](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaConsoleAuth](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaDefaultAuth](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaDomain](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaPwdProfile](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaPwdStrengthProfile](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaUserEp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pkiWebTokenData](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->