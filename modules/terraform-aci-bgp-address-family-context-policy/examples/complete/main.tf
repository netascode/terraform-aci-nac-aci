module "aci_bgp_address_family_context_policy" {
  source  = "netascode/bgp-address-family-context-policy/aci"
  version = ">= 0.1.0"

  name                   = "ABC"
  tenant                 = "TEN1"
  description            = "My BGP Policy"
  enable_host_route_leak = true
  ebgp_distance          = 21
  ibgp_distance          = 201
  local_distance         = 221
  local_max_ecmp         = 4
  ebgp_max_ecmp          = 8
  ibgp_max_ecmp          = 8
}
