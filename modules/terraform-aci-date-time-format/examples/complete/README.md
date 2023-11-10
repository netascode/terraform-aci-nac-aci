<!-- BEGIN_TF_DOCS -->
# Date Time Format Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_date_time_format" {
  source  = "netascode/date-time-format/aci"
  version = ">= 0.1.0"

  display_format = "utc"
  timezone       = "p120_Europe-Vienna"
  show_offset    = false
}
```
<!-- END_TF_DOCS -->