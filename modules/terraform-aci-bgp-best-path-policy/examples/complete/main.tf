module "aci_bgp_best_path_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bgp-best-path-policy"
  version = ">= 0.8.0"

  name                    = "ABC"
  tenant                  = "TEN1"
  description             = "My BGP Best Path Policy"
  as_path_multipath_relax = true
  ignore_igp_metric       = false
}
