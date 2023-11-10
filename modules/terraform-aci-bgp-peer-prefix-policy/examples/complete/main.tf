module "aci_bgp_peer_prefix_policy" {
  source  = "netascode/bgp-peer-prefix-policy/aci"
  version = ">= 0.1.0"

  name         = "ABC"
  tenant       = "TEN1"
  description  = "My BGP Peer Prefix Policy"
  action       = "restart"
  max_prefixes = 10000
  restart_time = 5000
  threshold    = 90
}
