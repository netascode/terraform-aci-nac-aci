<!-- BEGIN_TF_DOCS -->
# Terraform ACI DNS Policy Module

Manages ACI DNS Policy

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Global` » `DNS Profiles`

## Examples

```hcl
module "aci_dns_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-dns-policy"
  version = ">= 0.8.0"

  name          = "DNS1"
  mgmt_epg_type = "oob"
  mgmt_epg_name = "OOB1"
  providers_ = [{
    ip        = "10.1.1.1"
    preferred = true
  }]
  domains = [{
    name    = "cisco.com"
    default = true
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
| <a name="input_name"></a> [name](#input\_name) | DNS policy name. | `string` | n/a | yes |
| <a name="input_mgmt_epg_type"></a> [mgmt\_epg\_type](#input\_mgmt\_epg\_type) | Management endpoint group type. | `string` | `"inb"` | no |
| <a name="input_mgmt_epg_name"></a> [mgmt\_epg\_name](#input\_mgmt\_epg\_name) | Management endpoint group name. | `string` | `""` | no |
| <a name="input_providers_"></a> [providers\_](#input\_providers\_) | List of DNS providers. Default value `preferred`: false. | <pre>list(object({<br/>    ip        = string<br/>    preferred = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_domains"></a> [domains](#input\_domains) | List of domains. Default value `default`: false. | <pre>list(object({<br/>    name    = string<br/>    default = optional(bool, false)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `dnsProfile` object. |
| <a name="output_name"></a> [name](#output\_name) | DNS policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.dnsDomain](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dnsProfile](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dnsProv](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dnsRsProfileToEpg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->