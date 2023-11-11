<!-- BEGIN_TF_DOCS -->
# User Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_user" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-user"
  version = ">= 0.8.0"

  username         = "USER1"
  password         = "PASSWORD1"
  status           = "inactive"
  certificate_name = "CERT1"
  description      = "My Description"
  email            = "aa.aa@aa.aa"
  expires          = true
  expire_date      = "2031-01-20T10:00:00.000+00:00"
  first_name       = "First"
  last_name        = "Last"
  phone            = "1234567"
  domains = [{
    name = "all"
    roles = [{
      name           = "admin"
      privilege_type = "write"
    }]
  }]
}
```
<!-- END_TF_DOCS -->