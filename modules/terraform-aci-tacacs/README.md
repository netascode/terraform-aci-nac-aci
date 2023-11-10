<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-tacacs/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-tacacs/actions/workflows/test.yml)

# Terraform ACI TACACS Module

Manages ACI TACACS

Location in GUI:
`Admin` » `AAA` » `Authentication` » `TACACS`

## Examples

```hcl
module "aci_tacacs" {
  source  = "netascode/tacacs/aci"
  version = ">= 0.1.0"

  hostname_ip         = "1.1.1.1"
  description         = "My Description"
  protocol            = "chap"
  monitoring          = true
  monitoring_username = "USER1"
  monitoring_password = "PASSWORD1"
  key                 = "ABCDEFGH"
  port                = 149
  retries             = 3
  timeout             = 10
  mgmt_epg_type       = "oob"
  mgmt_epg_name       = "OOB1"
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
| <a name="input_hostname_ip"></a> [hostname\_ip](#input\_hostname\_ip) | Hostname or IP. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | Protocol. Choices: `pap`, `chap`, `mschap`. | `string` | `"pap"` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | Monitoring. | `bool` | `false` | no |
| <a name="input_monitoring_username"></a> [monitoring\_username](#input\_monitoring\_username) | Monitoring username. | `string` | `""` | no |
| <a name="input_monitoring_password"></a> [monitoring\_password](#input\_monitoring\_password) | Monitoring password. | `string` | `""` | no |
| <a name="input_key"></a> [key](#input\_key) | Key. | `string` | `""` | no |
| <a name="input_port"></a> [port](#input\_port) | Port. Minimum value: 0, Maximum value: 65535. | `number` | `49` | no |
| <a name="input_retries"></a> [retries](#input\_retries) | Retries. Minimum value: 0, Maximum value: 5. | `number` | `1` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Timeout. Minimum value: 0, Maximum value: 60. | `number` | `5` | no |
| <a name="input_mgmt_epg_type"></a> [mgmt\_epg\_type](#input\_mgmt\_epg\_type) | Management EPG type. Choices: `inb`, `oob`. | `string` | `"inb"` | no |
| <a name="input_mgmt_epg_name"></a> [mgmt\_epg\_name](#input\_mgmt\_epg\_name) | Management EPG name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `aaaTacacsPlusProvider` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.aaaRsSecProvToEpg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaTacacsPlusProvider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->