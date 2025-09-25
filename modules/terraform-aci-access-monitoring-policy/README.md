<!-- BEGIN_TF_DOCS -->
# Terraform ACI Access Monitoring Policy Module

Manages ACI Access Monitoring Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Monitoring` » `XXX`

## Examples

```hcl
module "aci_access_monitoring_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-monitoring-policy"
  version = "> 1.0.1"

  name = "test_mon_pol"
  snmp_trap_policies = [{
    name              = "test_trap"
    destination_group = "DAR"
  }]
  syslog_policies = [{
    name              = "test_syslog"
    audit             = false
    events            = false
    faults            = true
    session           = false
    minimum_severity  = "alerts"
    destination_group = "syslog_grp"
  }]
  fault_severity_policies = [{
    class = "l1PhysIf"
    faults = [{
      fault_id         = "F1696"
      initial_severity = "warning"
      target_severity  = "inherit"
      description      = "test"
    }]
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Access monitoring policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_snmp_trap_policies"></a> [snmp\_trap\_policies](#input\_snmp\_trap\_policies) | List of SNMP trap policies. | <pre>list(object({<br/>    name              = string<br/>    destination_group = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_syslog_policies"></a> [syslog\_policies](#input\_syslog\_policies) | List of syslog policies. Default value `audit`: true. Default value `events`: true. Default value `faults`: true. Default value `session`: false. Default value `minimum_severity`: `warnings`. | <pre>list(object({<br/>    name              = string<br/>    audit             = optional(bool, true)<br/>    events            = optional(bool, true)<br/>    faults            = optional(bool, true)<br/>    session           = optional(bool, false)<br/>    minimum_severity  = optional(string, "warnings")<br/>    destination_group = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_fault_severity_policies"></a> [fault\_severity\_policies](#input\_fault\_severity\_policies) | List of fault severity policies. | <pre>list(object({<br/>    class = string<br/>    faults = list(object({<br/>      fault_id         = string<br/>      initial_severity = optional(string, "inherit")<br/>      target_severity  = optional(string, "inherit")<br/>      description      = optional(string, "")<br/>    }))<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `monInfraPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Access monitoring policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.faultSevAsnP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.monInfraPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.monInfraTarget](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmpRsDestGroup](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmpSrc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.syslogRsDestGroup](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.syslogSrc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->