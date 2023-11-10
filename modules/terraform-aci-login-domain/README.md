<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-login-domain/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-login-domain/actions/workflows/test.yml)

# Terraform ACI Login Domain Module

Manages ACI Login Domain

Location in GUI:
`Admin` » `AAA` » `Authentication` » `AAA`

## Examples

```hcl
module "aci_login_domain" {
  source  = "netascode/login-domain/aci"
  version = ">= 0.2.0"

  name        = "TACACS1"
  description = "My Description"
  realm       = "tacacs"
  tacacs_providers = [{
    hostname_ip = "10.1.1.10"
    priority    = 10
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
| <a name="input_name"></a> [name](#input\_name) | Login domain name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm. Choices: `local`, `tacacs`, `ldap`. | `string` | n/a | yes |
| <a name="input_auth_choice"></a> [auth\_choice](#input\_auth\_choice) | Authentication choice. Choices: `CiscoAVPair`, `LdapGroupMap`. | `string` | `"CiscoAVPair"` | no |
| <a name="input_ldap_group_map"></a> [ldap\_group\_map](#input\_ldap\_group\_map) | LDAP group map. | `string` | `""` | no |
| <a name="input_tacacs_providers"></a> [tacacs\_providers](#input\_tacacs\_providers) | List of TACACS providers. Allowed values `priority`: 0-16. Default value `priority`: 0 | <pre>list(object({<br>    hostname_ip = string<br>    priority    = optional(number, 0)<br>  }))</pre> | `[]` | no |
| <a name="input_ldap_providers"></a> [ldap\_providers](#input\_ldap\_providers) | List of LDAP providers. Allowed values `priority`: 0-16. Default value `priority`: 0 | <pre>list(object({<br>    hostname_ip = string<br>    priority    = optional(number, 0)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `aaaLoginDomain` object. |
| <a name="output_name"></a> [name](#output\_name) | Login domain name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.aaaDomainAuth](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaLdapProviderGroup](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaLoginDomain](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaProviderRef](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaProviderRef_ldap](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaTacacsPlusProviderGroup](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->