<!-- BEGIN_TF_DOCS -->
# Tenant Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_tenant" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tenant"
  version = ">= 0.8.0"

  name        = "ABC"
  alias       = "ABC-ALIAS"
  description = "My Description"
}
```
<!-- END_TF_DOCS -->