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
