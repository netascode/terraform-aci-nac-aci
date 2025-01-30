<!-- BEGIN_TF_DOCS -->
# Terraform ACI VSPAN Destination Group Module

Manages ACI VSPAN Destination Group

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Troubleshooting` » `VSPAN` » `VSPAN Destination Groups`


## Examples

```hcl
module "aci_vspan_destination_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-vspan-destination-group"
  version = ">= 0.8.0"

  name        = "DST_GRP"
  description = "My VSPAN Destination Group"
  destinations = [
    {
      name        = "DST1"
      description = "Destination 1"
      ip          = "1.2.3.4"
      dscp        = "CS4"
      flow_id     = 10
      mtu         = 9000
      ttl         = 10
    },
    {
      name                = "DST2"
      description         = "Destination 2"
      tenant              = "Tenant-1"
      application_profile = "AP1"
      endpoint_group      = "EPG1"
      endpoint            = "01:23:45:67:89:AB"
    }
  ]
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
| <a name="input_name"></a> [name](#input\_name) | VSPAN destination group name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | VSPAN destination group description. | `string` | `""` | no |
| <a name="input_destinations"></a> [destinations](#input\_destinations) | List of VSPAN destinations. | <pre>list(object({<br/>    description         = optional(string, "")<br/>    name                = string<br/>    tenant              = optional(string)<br/>    application_profile = optional(string)<br/>    endpoint_group      = optional(string)<br/>    endpoint            = optional(string)<br/>    ip                  = optional(string)<br/>    mtu                 = optional(number, 1518)<br/>    ttl                 = optional(number, 64)<br/>    flow_id             = optional(number, 1)<br/>    dscp                = optional(string, "unspecified")<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `spanVDestGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | VSPAN Destination Group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.spanRsDestToVPort](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanVDest](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanVDestGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanVEpgSummary](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->