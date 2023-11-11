<!-- BEGIN_TF_DOCS -->
# System Performance Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

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
<!-- END_TF_DOCS -->