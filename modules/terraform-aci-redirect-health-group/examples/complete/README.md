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
  source  = "netascode/nac-aci/aci//modules/terraform-aci-redirect-health-group"
  version = ">= 0.8.0"

  name        = "ABC"
  tenant      = "TEN1"
  description = "My Description"
}
```
<!-- END_TF_DOCS -->