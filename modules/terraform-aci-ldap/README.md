<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-ldap/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-ldap/actions/workflows/test.yml)

# Terraform ACI LDAP Module

Description

Location in GUI:
`Admin` » `AAA` » `Authentication` » `LDAP`

## Examples

```hcl
module "aci_ldap" {
  source  = "netascode/ldap/aci"
  version = ">= 0.1.0"

  ldap_providers = [{
    hostname_ip          = "1.1.1.1"
    description          = "My Description"
    port                 = 149
    bind_dn              = "CN=testuser,OU=Employees,OU=Cisco users,DC=cisco,DC=com"
    base_dn              = "OU=Employees,OU=Cisco users,DC=cisco,DC=com"
    password             = "ABCDEFGH"
    timeout              = 10
    retries              = 3
    enable_ssl           = true
    filter               = "cn=$userid"
    attribute            = "memberOf"
    ssl_validation_level = "permissive"
    mgmt_epg_type        = "oob"
    mgmt_epg_name        = "OOB1"
    monitoring           = true
    monitoring_username  = "USER1"
    monitoring_password  = "PASSWORD1"
  }]
  group_map_rules = [{
    name        = "test-users-rules"
    description = "description"
    group_dn    = "CN=test-users,OU=Cisco groups,DC=cisco,DC=com"
    security_domains = [{
      name = "all"
      roles = [{
        name           = "admin"
        privilege_type = "read"
      }]
    }]
  }]
  group_maps = [{
    name  = "test-users-map"
    rules = ["test-users-rules"]
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
| <a name="input_ldap_providers"></a> [ldap\_providers](#input\_ldap\_providers) | LDAP Provider | <pre>list(object({<br>    hostname_ip          = string<br>    description          = optional(string, "")<br>    port                 = optional(number, 389)<br>    bind_dn              = optional(string, "")<br>    base_dn              = optional(string, "")<br>    password             = optional(string, "")<br>    timeout              = optional(number, 30)<br>    retries              = optional(number, 1)<br>    enable_ssl           = optional(bool, false)<br>    filter               = optional(string, "")<br>    attribute            = optional(string, "")<br>    ssl_validation_level = optional(string, "strict")<br>    mgmt_epg_type        = optional(string, "inb")<br>    mgmt_epg_name        = optional(string, "")<br>    monitoring           = optional(bool, false)<br>    monitoring_username  = optional(string, "default")<br>    monitoring_password  = optional(string, "")<br>  }))</pre> | `[]` | no |
| <a name="input_group_map_rules"></a> [group\_map\_rules](#input\_group\_map\_rules) | LDAP Group Map Rules | <pre>list(object({<br>    name        = string<br>    description = optional(string, "")<br>    group_dn    = optional(string, "")<br>    security_domains = optional(list(object({<br>      name = string<br>      roles = optional(list(object({<br>        name           = string<br>        privilege_type = optional(string, "read")<br>      })), [])<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_group_maps"></a> [group\_maps](#input\_group\_maps) | LDAP Group Maps | <pre>list(object({<br>    name  = string<br>    rules = list(string)<br>  }))</pre> | `[]` | no |

## Outputs

No outputs.

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.aaaLdapGroupMap](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaLdapGroupMapRule](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaLdapGroupMapRuleRef](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaLdapProvider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaRsSecProvToEpg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaUserDomain](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaUserRole](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->