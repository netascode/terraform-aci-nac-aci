module "aci_bgp_route_summarization_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bgp-route-summarization-policy"
  version = ">= 0.8.0"

  name         = "ABC"
  tenant       = "TEN1"
  description  = "My Description"
  as_set       = true
  summary_only = false
  af_mcast     = false
  af_ucast     = true
}
