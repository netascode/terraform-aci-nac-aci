<!-- BEGIN_TF_DOCS -->
# Terraform ACI Config Export Module

Manages ACI Config Export

Location in GUI:
`Admin` » `Import/Export` » `Export Policies` » `Configuration`

## Examples

```hcl
module "aci_config_export" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-config-export"
  version = ">= 0.8.0"

  name            = "EXP1"
  description     = "My Description"
  format          = "xml"
  snapshot        = true
  remote_location = "REMOTE1"
  scheduler       = "SCHEDULER1"
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
| <a name="input_name"></a> [name](#input\_name) | Config export policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_format"></a> [format](#input\_format) | Format. Choices: `json`, `xml`. | `string` | `"json"` | no |
| <a name="input_remote_location"></a> [remote\_location](#input\_remote\_location) | Remote location name. | `string` | `""` | no |
| <a name="input_scheduler"></a> [scheduler](#input\_scheduler) | Scheduler name. | `string` | `""` | no |
| <a name="input_snapshot"></a> [snapshot](#input\_snapshot) | Local configuration snapshot. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `configExportP` object. |
| <a name="output_name"></a> [name](#output\_name) | Config export policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.configExportP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.configRsExportScheduler](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.configRsRemotePath](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->