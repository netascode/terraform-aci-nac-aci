<!-- BEGIN_TF_DOCS -->
# Terraform ACI TACACS Monitoring Destination Module

Manages ACI TACACS Monitoring Destination Group

Location in GUI:
`Admin` » `External Data Collectors` » `Monitoring Destinations` » `TACACS`

## Examples

```hcl
module "aci_tacacs_monitoring_destination" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tacacs-monitoring-destination"
  version = ">= 0.8.0"

  name        = "TACACS_MON1"
  description = "My Description"
  destinations = [{
    hostname_ip   = "1.1.1.1"
    port          = 49
    protocol      = "pap"
    key           = "cisco123"
    mgmt_epg_type = "oob"
    mgmt_epg_name = "OOB1"
    }, {
    hostname_ip   = "2.2.2.2"
    port          = 49
    protocol      = "chap"
    mgmt_epg_type = "inb"
    mgmt_epg_name = "INB1"
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.19.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | TACACS monitoring destination group name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_destinations"></a> [destinations](#input\_destinations) | List of TACACS destinations. Allowed values `port`: 1-65535. Default value `port`: 49. Choices `protocol`: `pap`, `chap`, `mschap`. Default value `protocol`: `pap`. Choices `mgmt_epg_type`: `inb`, `oob`. Default value `mgmt_epg_type`: `oob`. | <pre>list(object({<br/>    hostname_ip   = string<br/>    port          = optional(number, 49)<br/>    protocol      = optional(string, "pap")<br/>    key           = optional(string)<br/>    mgmt_epg_type = optional(string, "oob")<br/>    mgmt_epg_name = optional(string)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `tacacsGroup` object. |
| <a name="output_name"></a> [name](#output\_name) | TACACS monitoring destination group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fileRsARemoteHostToEpg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.tacacsGroup](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.tacacsTacacsDest](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->