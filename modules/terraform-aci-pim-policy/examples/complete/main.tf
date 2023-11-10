module "aci_pim_policy" {
  source  = "netascode/pim-policy/aci"
  version = ">= 0.1.0"

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