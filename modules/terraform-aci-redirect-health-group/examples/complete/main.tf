module "redirect_health_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-redirect-health-group"
  version = ">= 0.8.0"

  name        = "ABC"
  tenant      = "TEN1"
  description = "My Description"
}
