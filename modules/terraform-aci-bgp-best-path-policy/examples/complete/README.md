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
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bgp-best-path-policy"
  version = ">= 0.8.0"

  name                    = "ABC"
  tenant                  = "TEN1"
  description             = "My BGP Best Path Policy"
  as_path_multipath_relax = true
  ignore_igp_metric       = false
}
```
<!-- END_TF_DOCS -->