<!-- BEGIN_TF_DOCS -->
# Atomic Counter Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_atomic_counter" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-atomic-counter"
  version = ">= 0.9.4"

  admin_state = true
  mode        = "trail"
}
```
<!-- END_TF_DOCS -->