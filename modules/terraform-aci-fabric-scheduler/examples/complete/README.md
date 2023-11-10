<!-- BEGIN_TF_DOCS -->
# Fabric Scheduler Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

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
<!-- END_TF_DOCS -->