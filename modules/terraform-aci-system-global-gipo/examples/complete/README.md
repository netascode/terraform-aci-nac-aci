<!-- BEGIN_TF_DOCS -->
# System Global GIPO Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_system_global_gipo" {
  source  = "netascode/system-global-gipo/aci"
  version = ">= 0.1.0"

  use_infra_gipo = true
}
```
<!-- END_TF_DOCS -->