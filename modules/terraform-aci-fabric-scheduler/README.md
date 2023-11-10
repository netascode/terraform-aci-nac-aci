<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-fabric-scheduler/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-fabric-scheduler/actions/workflows/test.yml)

# Terraform ACI Fabric Scheduler Module

Manages ACI Fabric Scheduler

Location in GUI:
`Admin` » `Schedulers` » `Fabric`

## Examples

```hcl
module "aci_fabric_scheduler" {
  source  = "netascode/fabric-scheduler/aci"
  version = ">= 0.2.0"

  name        = "SCHED1"
  description = "My Description"
  recurring_windows = [{
    name   = "EVEN-DAY"
    day    = "even-day"
    hour   = 2
    minute = 10
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
| <a name="input_name"></a> [name](#input\_name) | Fabric scheduler name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_recurring_windows"></a> [recurring\_windows](#input\_recurring\_windows) | List of recurring windows. Choices `day`: `every-day`, `odd-day`, `even-day`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday`, `Sunday`. Allowed values `hour`: 0-23. Allowed values `minute`: 0-59. | <pre>list(object({<br>    name   = string<br>    day    = optional(string, "every-day")<br>    hour   = optional(number, 0)<br>    minute = optional(number, 0)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `trigSchedP` object. |
| <a name="output_name"></a> [name](#output\_name) | Fabric scheduler name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.trigRecurrWindowP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.trigSchedP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->