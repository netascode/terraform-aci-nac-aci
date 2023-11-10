<!-- BEGIN_TF_DOCS -->
# Redirect Health Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "redirect_health_group" {
  source  = "netascode/redirect-health-group/aci"
  version = ">= 0.1.0"

  name        = "ABC"
  tenant      = "TEN1"
  description = "My Description"
}
```
<!-- END_TF_DOCS -->