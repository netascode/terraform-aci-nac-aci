<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-contract/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-contract/actions/workflows/test.yml)

# Terraform ACI Contract Module

Manages ACI Contract

Location in GUI:
`Tenants` » `XXX` » `Contracts` » `Standard`

## Examples

```hcl
module "aci_contract" {
  source  = "netascode/contract/aci"
  version = ">= 0.2.0"

  tenant      = "ABC"
  name        = "CON1"
  alias       = "CON1-ALIAS"
  description = "My Description"
  scope       = "global"
  qos_class   = "level4"
  target_dscp = "CS0"
  subjects = [{
    name          = "SUB1"
    alias         = "SUB1-ALIAS"
    description   = "Subject Description"
    service_graph = "SG1"
    qos_class     = "level5"
    target_dscp   = "CS1"
    filters = [{
      filter   = "FILTER1"
      action   = "deny"
      priority = "level1"
      log      = true
      no_stats = true
    }]
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
| <a name="input_name"></a> [name](#input\_name) | Contract name. | `string` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | Contract alias. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Contract description. | `string` | `""` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | Contract scope. Choices: `application-profile`, `tenant`, `context`, `global`. | `string` | `"context"` | no |
| <a name="input_qos_class"></a> [qos\_class](#input\_qos\_class) | Contract QoS Class. Choices: `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5`, `level6`. | `string` | `"unspecified"` | no |
| <a name="input_target_dscp"></a> [target\_dscp](#input\_target\_dscp) | Contract Target DSCP. Valid values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63. | `string` | `"unspecified"` | no |
| <a name="input_subjects"></a> [subjects](#input\_subjects) | List of contract subjects. Choices `action`: `permit`, `deny`. Default value `action`: `permit`. Choices `priority`: `default`, `level1`, `level2`, `level3`. Default value `priority`: `default`. Default value `log`: `false`. Default value `no_stats`: `false`. Choices `qos_class`: `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or`level6`. Default value `qos_class`: `unspecified`. Choices `dscp_target` : `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6` `CS7` or a number between 0 and 63. Default value `dscp_target`: `unspecified` | <pre>list(object({<br>    name          = string<br>    alias         = optional(string, "")<br>    description   = optional(string, "")<br>    service_graph = optional(string)<br>    qos_class     = optional(string, "unspecified")<br>    target_dscp   = optional(string, "unspecified")<br>    filters = optional(list(object({<br>      filter   = string<br>      action   = optional(string, "permit")<br>      priority = optional(string, "default")<br>      log      = optional(bool, false)<br>      no_stats = optional(bool, false)<br>    })), [])<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vzBrCP` object. |
| <a name="output_name"></a> [name](#output\_name) | Contract name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vzBrCP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsSubjFiltAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsSubjGraphAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzSubj](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->