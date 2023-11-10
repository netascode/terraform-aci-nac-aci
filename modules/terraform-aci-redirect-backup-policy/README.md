<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-redirect-backup-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-redirect-backup-policy/actions/workflows/test.yml)

# Terraform ACI Redirect Backup Policy Module

Manages ACI Redirect Backup Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `L4-L7 Policy-Based Redirect Backup`

## Examples

```hcl
module "aci_redirect_backup_policy" {
  source  = "netascode/redirect-backup-policy/aci"
  version = ">= 0.1.0"

  tenant      = "ABC"
  name        = "REDIRECT1"
  description = "My Description"
  l3_destinations = [{
    name                  = "DEST1"
    description           = "L3 description"
    ip                    = "1.1.1.1"
    ip_2                  = "1.1.1.2"
    mac                   = "00:01:02:03:04:05"
    redirect_health_group = "HEALTH_GRP1"
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Redirect backup policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_l3_destinations"></a> [l3\_destinations](#input\_l3\_destinations) | List of L3 destinations. | <pre>list(object({<br>    name                  = optional(string, "")<br>    description           = optional(string, "")<br>    ip                    = string<br>    ip_2                  = optional(string)<br>    mac                   = string<br>    redirect_health_group = optional(string, "")<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vnsBackupPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Redirect backup policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vnsBackupPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRedirectDest](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vnsRsRedirectHealthGroup](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->