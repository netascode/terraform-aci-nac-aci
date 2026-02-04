<!-- BEGIN_TF_DOCS -->
# Common Monitoring Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_monitoring_policy" {
  source  = "netascode/nac-aci/aci/modules/terraform-aci-monitoring-policy"
  version = "> 1.2.0"

  snmp_trap_policies = [{
    name              = "SNMP1"
    destination_group = "DST1"
  }]
  syslog_policies = [{
    name              = "SYSLOG1"
    audit             = false
    events            = false
    faults            = false
    session           = true
    minimum_severity  = "alerts"
    destination_group = "DST1"
  }]
}
```
<!-- END_TF_DOCS -->