<!-- BEGIN_TF_DOCS -->
# Monitoring Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_monitoring_policy_user_defined" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-monitoring-policy-user-defined"
  version = "> 1.0.1"

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
<!-- END_TF_DOCS -->