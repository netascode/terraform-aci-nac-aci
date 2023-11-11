module "aci_nd_ra_prefix_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-nd-ra-prefix-policy"
  version = ">= 0.8.0"

  tenant             = "ABC"
  name               = "NDRA1"
  description        = "My Description"
  valid_lifetime     = 1000
  preferred_lifetime = 10000
  auto_configuration = false
  on_link            = false
  router_address     = false
}
