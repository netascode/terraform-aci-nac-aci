<!-- BEGIN_TF_DOCS -->
# PSU Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_psu_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-psu-policy"
  version = ">= 0.8.0"

  name        = "PSU1"
  admin_state = "nnred"
}
```
<!-- END_TF_DOCS -->