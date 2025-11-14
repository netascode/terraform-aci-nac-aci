<!-- BEGIN_TF_DOCS -->
# Terraform ACI Monitoring Policy Module

Manages ACI Monitoring Policy

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Monitoring` » `Common Policy`

## Examples

```hcl
module "aci_monitoring_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-monitoring-policy"
  version = ">= 0.8.0"

  snmp_trap_policies = ["SNMP1"]
  syslog_policies = [{
    name             = "SYSLOG1"
    audit            = false
    events           = false
    faults           = false
    session          = true
    minimum_severity = "alerts"
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
| <a name="input_snmp_trap_policies"></a> [snmp\_trap\_policies](#input\_snmp\_trap\_policies) | List of SNMP trap policy names. | `list(string)` | `[]` | no |
| <a name="input_syslog_policies"></a> [syslog\_policies](#input\_syslog\_policies) | List of syslog policies. Default value `audit`: true. Default value `events`: true. Default value `faults`: true. Default value `session`: false. Default value `minimum_severity`: `warnings`. | <pre>list(object({<br/>    name             = string<br/>    audit            = optional(bool, true)<br/>    events           = optional(bool, true)<br/>    faults           = optional(bool, true)<br/>    session          = optional(bool, false)<br/>    minimum_severity = optional(string, "warnings")<br/>  }))</pre> | `[]` | no |

## Outputs

No outputs.

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.snmpRsDestGroup](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmpSrc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.syslogRsDestGroup](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.syslogSrc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->