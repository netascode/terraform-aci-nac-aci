module "aci_bgp_peer_prefix_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bgp-peer-prefix-policy"
  version = ">= 0.8.0"

  name         = "ABC"
  tenant       = "TEN1"
  description  = "My BGP Peer Prefix Policy"
  action       = "restart"
  max_prefixes = 10000
  restart_time = 5000
  threshold    = 90
}
