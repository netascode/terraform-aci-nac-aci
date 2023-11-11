<!-- BEGIN_TF_DOCS -->
# PIM Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_pim_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-im-policy"
  version = ">= 0.8.0"

  name                         = "ABC"
  tenant                       = "PIM1"
  auth_key                     = "myKey"
  auth_type                    = "ah-md5"
  mcast_dom_boundary           = true
  passive                      = true
  strict_rfc                   = true
  designated_router_delay      = 6
  designated_router_priority   = 5
  hello_interval               = 10
  join_prune_interval          = 120
  neighbor_filter_policy       = "NEIGH_RM"
  join_prune_filter_policy_in  = "IN_RM"
  join_prune_filter_policy_out = "OUT_RM"
}
```
<!-- END_TF_DOCS -->