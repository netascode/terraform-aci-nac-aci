module "aci_bgp_policy" {
  source  = "netascode/bgp-policy/aci"
  version = ">= 0.2.0"

  fabric_bgp_as = 65000
  fabric_bgp_rr = [{
    node_id = 2001
    pod_id  = 2
  }]
  fabric_bgp_external_rr = [{
    node_id = 2001
    pod_id  = 2
  }]
}
