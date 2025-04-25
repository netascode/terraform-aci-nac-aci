<!-- BEGIN_TF_DOCS -->
# Terraform ACI Date Time Policy Module

Manages ACI Date Time Policy

Location in GUI:
`Fabric` » `Fabric Policies` » `Fabric Policies` » `Policies` » `Pod` » `Date and Time`

## Examples

```hcl
module "aci_date_time_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-date-time-policy"
  version = ">= 0.8.0"

  name                           = "DATE1"
  apic_ntp_server_master_stratum = 10
  ntp_admin_state                = false
  ntp_auth_state                 = true
  apic_ntp_server_master_mode    = true
  apic_ntp_server_state          = true
  ntp_servers = [{
    hostname_ip   = "100.1.1.1"
    preferred     = true
    mgmt_epg_type = "inb"
    mgmt_epg_name = "INB1"
    auth_key_id   = 1
  }]
  ntp_keys = [{
    id        = 1
    key       = "SECRETKEY"
    auth_type = "sha1"
    trusted   = true
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
| <a name="input_name"></a> [name](#input\_name) | Date time policy Name. | `string` | n/a | yes |
| <a name="input_apic_ntp_server_master_stratum"></a> [apic\_ntp\_server\_master\_stratum](#input\_apic\_ntp\_server\_master\_stratum) | APIC NTP server master stratum. Minimum value: 1. Maximum value: 14. | `number` | `8` | no |
| <a name="input_ntp_admin_state"></a> [ntp\_admin\_state](#input\_ntp\_admin\_state) | NTP admin state. | `bool` | `true` | no |
| <a name="input_ntp_auth_state"></a> [ntp\_auth\_state](#input\_ntp\_auth\_state) | NTP authentication state. | `bool` | `false` | no |
| <a name="input_apic_ntp_server_master_mode"></a> [apic\_ntp\_server\_master\_mode](#input\_apic\_ntp\_server\_master\_mode) | APIC NTP server master mode. | `bool` | `false` | no |
| <a name="input_apic_ntp_server_state"></a> [apic\_ntp\_server\_state](#input\_apic\_ntp\_server\_state) | APIC NTP server state. | `bool` | `false` | no |
| <a name="input_ntp_servers"></a> [ntp\_servers](#input\_ntp\_servers) | List of NTP servers. Default value `preferred`: false. Choices `mgmt_epg_type`: `inb`, `oob`. Default value `mgmt_epg_type`: `inb`. Allowed values `auth_key_id`: 1-65535. | <pre>list(object({<br/>    hostname_ip   = string<br/>    preferred     = optional(bool, false)<br/>    mgmt_epg_type = optional(string, "inb")<br/>    mgmt_epg_name = optional(string)<br/>    auth_key_id   = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_ntp_keys"></a> [ntp\_keys](#input\_ntp\_keys) | List of keys. Allowed values `id`: 1-65535. Choices `auth_type`: `md5`, `sha1`. | <pre>list(object({<br/>    id        = number<br/>    key       = string<br/>    auth_type = string<br/>    trusted   = bool<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `datetimePol` object. |
| <a name="output_name"></a> [name](#output\_name) | Date time policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.datetimeNtpAuthKey](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.datetimeNtpProv](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.datetimePol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.datetimeRsNtpProvToEpg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.datetimeRsNtpProvToNtpAuthKey](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->