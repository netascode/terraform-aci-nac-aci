<!-- BEGIN_TF_DOCS -->
# Terraform ACI System Performance Module

Manage ACI Global System Performance settings

Location in GUI:
'System' » 'System Settings' » 'System Performance'

## Examples

```hcl
module "system_performance" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-system-performance"
  version = ">= 0.8.0"

  admin_state          = true
  response_threshold   = 8500
  top_slowest_requests = 5
  calculation_window   = 300
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
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | System Performance administrative state. | `bool` | `false` | no |
| <a name="input_response_threshold"></a> [response\_threshold](#input\_response\_threshold) | Threshold value for response time of any requests to Nginx. | `number` | `85000` | no |
| <a name="input_top_slowest_requests"></a> [top\_slowest\_requests](#input\_top\_slowest\_requests) | Property to set the number of slowest requests to be seen. | `number` | `5` | no |
| <a name="input_calculation_window"></a> [calculation\_window](#input\_calculation\_window) | Window in which average time, and number of requests that go beyond the threshold is calculated. | `number` | `300` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `commApiRespTime` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.commApiRespTime](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->