<!-- BEGIN_TF_DOCS -->
# Terraform ACI Monitoring Policy Module

Manages ACI Monitoring Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Monitoring`

## Examples

```hcl
module "aci_infra_monitoring_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-monitoring-policy"
  version = ">= 0.8.0"

  name        = "INFRA-MONITORING-POL"
  description = "My Description"
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
| <a name="input_name"></a> [name](#input\_name) | Monitoring policy name. | `string` | n/a | yes |
| <a name="input_description"></a> description | Description. | string | "" | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `monInfraPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Monitoring policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.monInfraPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->