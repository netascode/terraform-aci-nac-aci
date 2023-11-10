module "aci_bgp_best_path_policy" {
  source  = "netascode/bgp-best-path-policy/aci"
  version = ">= 0.1.0"

  name         = "ABC"
  tenant       = "TEN1"
  description  = "My BGP Best Path Policy"
  control_type = "multi-path-relax"
}
