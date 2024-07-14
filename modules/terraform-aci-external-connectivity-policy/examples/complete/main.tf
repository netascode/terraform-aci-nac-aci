module "aci_external_connectivity_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-external-connectivity-policy"
  version = ">= 0.8.0"

  name         = "EXT-POL1"
  route_target = "extended:as2-nn4:5:17"
  fabric_id    = 2
  site_id      = 2
  peering_type = "route_reflector"
  bgp_password = "SECRETPW"
  routing_profiles = [{
    name        = "PROF1"
    description = "My Description"
    subnets     = ["10.0.0.0/24"]
  }]
  data_plane_teps = [{
    pod_id = 2
    ip     = "11.1.1.11"
  }]
  unicast_teps = [{
    pod_id = 2
    ip     = "1.2.3.4"
  }]
}
