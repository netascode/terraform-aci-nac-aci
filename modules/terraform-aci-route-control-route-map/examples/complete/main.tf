module "aci_route_control_route_map" {
  source  = "netascode/route-control-route-map/aci"
  version = ">= 0.0.1"

  name        = "ABC"
  description = "My Description"
  tenant      = "TEN1"
  contexts = [
    {
      name        = "CTX1"
      description = "My Context 1"
      action      = "deny"
      order       = 1
      set_rule    = "SET1"
      match_rules = ["MATCH1"]
    },
    {
      name        = "CTX2"
      match_rules = ["MATCH2", "MATCH3"]
    }
  ]
}
