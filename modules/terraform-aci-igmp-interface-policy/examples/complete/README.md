<!-- BEGIN_TF_DOCS -->
# IGMP Interface Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_igmp_interface_policy" {
  source  = "netascode/igmp-interface-policy/aci"
  version = ">= 0.1.0"

  name                              = "ABC"
  tenant                            = "TEN1"
  description                       = "My IGMP Interface Policy"
  grp_timeout                       = 10
  allow_v3_asm                      = true
  fast_leave                        = true
  report_link_local_groups          = true
  last_member_count                 = 5
  last_member_response_time         = 5
  querier_timeout                   = 10
  query_interval                    = 10
  robustness_variable               = 3
  query_response_interval           = 7
  startup_query_count               = 7
  startup_query_interval            = 7
  version_                          = "v3"
  report_policy_multicast_route_map = "RM1"
  static_report_multicast_route_map = "RM2"
  max_mcast_entries                 = 1000
  reserved_mcast_entries            = 100
  state_limit_multicast_route_map   = "RM3"
}
```
<!-- END_TF_DOCS -->