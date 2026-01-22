<!-- BEGIN_TF_DOCS -->
# Terraform ACI Custom Monitoring Policy Module

Manages ACI Custom Monitoring Policy

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Monitoring`

## Examples

```hcl
module "aci_monitoring_policy_custom" {
  source  = "netascode/nac-aci/aci/modules/terraform-aci-monitoring-policy-custom"
  version = "> 1.2.0"

  name = "MON1"
  snmp_trap_policies = [{
    name              = "SNMP_1"
    destination_group = "SNMP_DEST_GROUP1"
  }]
  syslog_policies = [{
    name              = "SYSLOG1"
    audit             = false
    events            = false
    faults            = false
    session           = true
    minimum_severity  = "alerts"
    destination_group = "SYSLOG_DEST_GROUP1"
  }]
  fault_severity_policies = [{
    class = "snmpClient"
    faults = [{
      fault_id         = "F1368"
      description      = "Fault 1368 nice description"
      initial_severity = "critical"
      target_severity  = "inherit"
    }]
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.15.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Track List name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_snmp_trap_policies"></a> [snmp\_trap\_policies](#input\_snmp\_trap\_policies) | List of SNMP trap policies. | <pre>list(object({<br/>    name              = string<br/>    destination_group = optional(string, "")<br/>  }))</pre> | `[]` | no |
| <a name="input_syslog_policies"></a> [syslog\_policies](#input\_syslog\_policies) | List of syslog policies. Default value `audit`: true. Default value `events`: true. Default value `faults`: true. Default value `session`: false. Default value `minimum_severity`: `warnings`. | <pre>list(object({<br/>    name              = string<br/>    audit             = optional(bool, true)<br/>    events            = optional(bool, true)<br/>    faults            = optional(bool, true)<br/>    session           = optional(bool, false)<br/>    minimum_severity  = optional(string, "warnings")<br/>    destination_group = optional(string, "")<br/>  }))</pre> | `[]` | no |
| <a name="input_fault_severity_policies"></a> [fault\_severity\_policies](#input\_fault\_severity\_policies) | List of Fault Severity Assignment Policies. | <pre>list(object({<br/>    class = string<br/>    faults = list(object({<br/>      fault_id         = string<br/>      initial_severity = optional(string, "inherit")<br/>      target_severity  = optional(string, "inherit")<br/>      description      = optional(string, "")<br/>    }))<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of Fabric `monFabricPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Custom Fabric Monitoring Policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.faultSevAsnP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.monFabricPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.monFabricTarget](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmpRsDestGroup](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmpSrc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.syslogRsDestGroup](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.syslogSrc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->