<!-- BEGIN_TF_DOCS -->
# IGMP Snooping Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_igmp_snooping_policy" {
  source  = "netascode/igmp-snooping-policy/aci"
  version = ">= 0.1.0"

  name                       = "ABC"
  tenant                     = "TEN1"
  description                = "My IGMP Snooping Policy"
  admin_state                = false
  fast_leave                 = true
  querier                    = true
  last_member_query_interval = 10
  query_interval             = 100
  query_response_interval    = 10
  start_query_count          = 10
  start_query_interval       = 10
}
```
<!-- END_TF_DOCS -->