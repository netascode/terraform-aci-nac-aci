<!-- BEGIN_TF_DOCS -->
# Terraform ACI Syslog Policy Module

Manages ACI Syslog Policy

Location in GUI:
`Admin` » `External Data Collectors` » `Monitoring Destinations` » `Syslog`

## Examples

```hcl
module "aci_syslog_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-syslog-policy"
  version = ">= 0.8.0"

  name                = "SYSLOG1"
  description         = "My Description"
  format              = "nxos"
  show_millisecond    = true
  show_timezone       = true
  admin_state         = true
  local_admin_state   = false
  local_severity      = "errors"
  console_admin_state = false
  console_severity    = "critical"
  destinations = [{
    name          = "DEST1"
    hostname_ip   = "1.1.1.1"
    protocol      = "tcp"
    port          = 1514
    admin_state   = false
    format        = "nxos"
    facility      = "local1"
    severity      = "information"
    mgmt_epg_type = "oob"
    mgmt_epg_name = "OOB1"
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
| <a name="input_name"></a> [name](#input\_name) | Syslog policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_format"></a> [format](#input\_format) | Format. Choices: `aci`, `nxos`, `enhanced-log`. | `string` | `"aci"` | no |
| <a name="input_show_millisecond"></a> [show\_millisecond](#input\_show\_millisecond) | Show milliseconds. | `bool` | `false` | no |
| <a name="input_show_timezone"></a> [show\_timezone](#input\_show\_timezone) | Show timezone. | `bool` | `false` | no |
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | Admin state. | `bool` | `true` | no |
| <a name="input_local_admin_state"></a> [local\_admin\_state](#input\_local\_admin\_state) | Local admin state. | `bool` | `true` | no |
| <a name="input_local_severity"></a> [local\_severity](#input\_local\_severity) | Local severity. Choices: `emergencies`, `alerts`, `critical`, `errors`, `warnings`, `notifications`, `information`, `debugging`. | `string` | `"information"` | no |
| <a name="input_console_admin_state"></a> [console\_admin\_state](#input\_console\_admin\_state) | Console admin state. | `bool` | `true` | no |
| <a name="input_console_severity"></a> [console\_severity](#input\_console\_severity) | Console severity. Choices: `emergencies`, `alerts`, `critical`, `errors`, `warnings`, `notifications`, `information`, `debugging`. | `string` | `"alerts"` | no |
| <a name="input_destinations"></a> [destinations](#input\_destinations) | List of destinations. Allowed values `protocol`: `udp`, `tcp`, `ssl`. Allowed values `port`: 0-65535. Default value `port`: 514. Choices `format`: `aci`, `nxos`. Default value `format`: `aci`. Choices `facility`: `local0`, `local1` ,`local2` ,`local3` ,`local4` ,`local5`, `local6`, `local7`. Default value `facility`: `local7`. Choices `severity`: `emergencies`, `alerts`, `critical`, `errors`, `warnings`, `notifications`, `information`, `debugging`. Default value `severity`: `warnings`. Choices `mgmt_epg_type`: `inb`, `oob`. Default value `mgmt_epg_type`: `inb`. | <pre>list(object({<br/>    name          = optional(string, "")<br/>    hostname_ip   = string<br/>    protocol      = optional(string)<br/>    port          = optional(number, 514)<br/>    admin_state   = optional(bool, true)<br/>    format        = optional(string, "aci")<br/>    facility      = optional(string, "local7")<br/>    severity      = optional(string, "warnings")<br/>    mgmt_epg_type = optional(string, "inb")<br/>    mgmt_epg_name = optional(string)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `syslogGroup` object. |
| <a name="output_name"></a> [name](#output\_name) | Syslog policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fileRsARemoteHostToEpg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.syslogConsole](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.syslogFile](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.syslogGroup](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.syslogProf](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.syslogRemoteDest](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->