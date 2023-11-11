<!-- BEGIN_TF_DOCS -->
# Application Profile Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_application_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-application-profile"
  version = ">= 0.8.0"

  tenant      = "ABC"
  name        = "AP1"
  alias       = "AP1-ALIAS"
  description = "My Description"
}
```
<!-- END_TF_DOCS -->