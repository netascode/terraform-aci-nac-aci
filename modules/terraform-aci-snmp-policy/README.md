<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-snmp-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-snmp-policy/actions/workflows/test.yml)

# Terraform ACI SNMP Policy Module

Manages ACI SNMP Policy

Location in GUI:
`Fabric Policies` » `Policies` » `Pod` » `SNMP`

## Examples

```hcl
module "aci_snmp_policy" {
  source  = "netascode/snmp-policy/aci"
  version = ">= 0.2.0"

  name        = "SNMP1"
  admin_state = true
  location    = "LOC"
  contact     = "CON"
  communities = ["COM1"]
  users = [{
    name               = "USER1"
    privacy_type       = "aes-128"
    privacy_key        = "ABCDEFGH"
    authorization_type = "hmac-sha1-96"
    authorization_key  = "ABCDEFGH"
  }]
  trap_forwarders = [{
    ip   = "1.1.1.1"
    port = 1162
  }]
  clients = [{
    name          = "CLIENT1"
    mgmt_epg_type = "oob"
    mgmt_epg_name = "OOB1"
    entries = [{
      ip   = "10.1.1.1"
      name = "NMS1"
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
| <a name="input_name"></a> [name](#input\_name) | SNMP policy name. | `string` | n/a | yes |
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | Admin state. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Location. | `string` | `""` | no |
| <a name="input_contact"></a> [contact](#input\_contact) | Contact. | `string` | `""` | no |
| <a name="input_communities"></a> [communities](#input\_communities) | List of communities. | `list(string)` | `[]` | no |
| <a name="input_users"></a> [users](#input\_users) | List of users. Choices `privacy_type`: `none`, `des`, `aes-128`. Default value `privacy_type`: `none`. `privacy_key`: Minimum characters: 8. Maximum characters: 130. Choices `authorization_type`: `hmac-md5-96`, `hmac-sha1-96`, `hmac-sha2-224`, `hmac-sha2-256`, `hmac-sha2-384`, `hmac-sha2-512`. Default value `authorization_type`: `mac-md5-96`. `authorization_key`: Minimum characters: 8. Maximum characters: 130. | <pre>list(object({<br>    name               = string<br>    privacy_type       = optional(string, "none")<br>    privacy_key        = optional(string)<br>    authorization_type = optional(string, "hmac-md5-96")<br>    authorization_key  = optional(string, "")<br>  }))</pre> | `[]` | no |
| <a name="input_trap_forwarders"></a> [trap\_forwarders](#input\_trap\_forwarders) | List of trap forwarders. Allowed values `port`: 0-65535. Default value `port`: 162. | <pre>list(object({<br>    ip   = string<br>    port = optional(number, 162)<br>  }))</pre> | `[]` | no |
| <a name="input_clients"></a> [clients](#input\_clients) | List of clients. Choices `mgmt_epg_type`: `inb`, `oob`. Default value `mgmt_epg_type`: `inb`. | <pre>list(object({<br>    name          = string<br>    mgmt_epg_type = optional(string, "inb")<br>    mgmt_epg_name = optional(string)<br>    entries = optional(list(object({<br>      ip   = string<br>      name = string<br>    })), [])<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `snmpPol` object. |
| <a name="output_name"></a> [name](#output\_name) | SNMP policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.snmpClientGrpP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmpClientP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmpCommunityP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmpPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmpRsEpg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmpTrapFwdServerP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmpUserP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->