module "redirect_health_group" {
  source  = "netascode/redirect-health-group/aci"
  version = ">= 0.1.0"

  name        = "ABC"
  tenant      = "TEN1"
  description = "My Description"
}
