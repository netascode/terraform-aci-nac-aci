<!-- BEGIN_TF_DOCS -->
# Terraform ACI Service EPG Policy Module

Manages ACI Service EPG Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `L4-L7 Service EPG Policy`

## Examples

```hcl
module "aci_service_epg_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-service-epg-policy"
  version = ">= 0.8.0"

  tenant          = "ABC"
  name            = "SERVICE_EPG_POLICY_1"
  description     = "My Description"
  preferred_group = true
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
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Service EPG policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Service EPG policy description. | `string` | `""` | no |
| <a name="input_preferred_group"></a> [preferred\_group](#input\_preferred\_group) | Preferred group flag. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vnsSvcEPgPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Service EPG policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vnsSvcEPgPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->