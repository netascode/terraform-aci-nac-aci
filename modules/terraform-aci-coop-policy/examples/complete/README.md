<!-- BEGIN_TF_DOCS -->
# COOP Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_coop_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-coop-policy"
  version = ">= 0.8.0"

  coop_group_policy = "strict"
}
```
<!-- END_TF_DOCS -->