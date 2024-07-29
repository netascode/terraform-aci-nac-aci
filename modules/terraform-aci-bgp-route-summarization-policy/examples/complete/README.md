<!-- BEGIN_TF_DOCS -->
# BGP Route Summarization Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_bgp_route_summarization_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bgp-route-summarization-policy"
  version = ">= 0.8.0"

  name         = "ABC"
  tenant       = "TEN1"
  description  = "My Description"
  as_set       = true
  summary_only = false
  af_mcast     = false
  af_ucast     = true
}
```
<!-- END_TF_DOCS -->