<!-- BEGIN_TF_DOCS -->
# BGP Best Path Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_bgp_best_path_policy" {
  source  = "netascode/bgp-best-path-policy/aci"
  version = ">= 0.1.0"

  name         = "ABC"
  tenant       = "TEN1"
  description  = "My BGP Best Path Policy"
  control_type = "multi-path-relax"
}
```
<!-- END_TF_DOCS -->