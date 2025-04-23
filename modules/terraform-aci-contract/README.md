<!-- BEGIN_TF_DOCS -->
# Terraform ACI Contract Module

Manages ACI Contract

Location in GUI:
`Tenants` » `XXX` » `Contracts` » `Standard`

## Examples

```hcl
module "aci_contract" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-contract"
  version = ">= 0.8.0"

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
    },
    {
      name                               = "SUB2"
      alias                              = "SUB2-ALIAS"
      description                        = "Subject Description"
      service_graph                      = "SG1"
      qos_class                          = "level5"
      target_dscp                        = "CS1"
      reverse_filter_ports               = false
      consumer_to_provider_service_graph = "SG1"
      consumer_to_provider_qos           = "level5"
      consumer_to_provider_dscp          = "CS1"
      consumer_to_provider_filters = [{
        filter   = "FILTER1"
        action   = "deny"
        priority = "level1"
        log      = true
        no_stats = true
      }]
      provider_to_consumer_service_graph = "SG1"
      provider_to_consumer_qos           = "level5"
      provider_to_consumer_dscp          = "CS1"
      provider_to_consumer_filters = [{
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
| <a name="input_subjects"></a> [subjects](#input\_subjects) | List of contract subjects. Choices `action`: `permit`, `deny`. Default value `action`: `permit`. Choices `priority`: `default`, `level1`, `level2`, `level3`. Default value `priority`: `default`. Default value `log`: `false`. Default value `no_stats`: `false`. Choices `qos_class`: `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`. Default value `qos_class`: `unspecified`. Choices `dscp_target` : `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6` `CS7` or a number between 0 and 63. Default value `dscp_target`: `unspecified` | <pre>list(object({<br/>    name                 = string<br/>    alias                = optional(string, "")<br/>    description          = optional(string, "")<br/>    reverse_filter_ports = optional(bool, true)<br/>    service_graph        = optional(string)<br/>    qos_class            = optional(string, "unspecified")<br/>    target_dscp          = optional(string, "unspecified")<br/>    filters = optional(list(object({<br/>      filter   = string<br/>      action   = optional(string, "permit")<br/>      priority = optional(string, "default")<br/>      log      = optional(bool, false)<br/>      no_stats = optional(bool, false)<br/>    })), [])<br/><br/>    consumer_to_provider_service_graph = optional(string)<br/>    consumer_to_provider_qos_class     = optional(string, "unspecified")<br/>    consumer_to_provider_target_dscp   = optional(string, "unspecified")<br/>    consumer_to_provider_filters = optional(list(object({<br/>      filter   = string<br/>      action   = optional(string, "permit")<br/>      priority = optional(string, "default")<br/>      log      = optional(bool, false)<br/>      no_stats = optional(bool, false)<br/>    })), [])<br/>    provider_to_consumer_service_graph = optional(string)<br/>    provider_to_consumer_qos_class     = optional(string, "unspecified")<br/>    provider_to_consumer_target_dscp   = optional(string, "unspecified")<br/>    provider_to_consumer_filters = optional(list(object({<br/>      filter   = string<br/>      action   = optional(string, "permit")<br/>      priority = optional(string, "default")<br/>      log      = optional(bool, false)<br/>      no_stats = optional(bool, false)<br/>  })), []) }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vzBrCP` object. |
| <a name="output_name"></a> [name](#output\_name) | Contract name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vzBrCP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzInTerm](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzOutTerm](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsFiltAtt_ctp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsFiltAtt_ptc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsInTermGraphAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsOutTermGraphAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsSubjFiltAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzRsSubjGraphAtt](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vzSubj](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->