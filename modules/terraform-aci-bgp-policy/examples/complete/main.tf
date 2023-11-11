module "aci_bgp_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bgp-policy"
  version = ">= 0.8.0"

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
