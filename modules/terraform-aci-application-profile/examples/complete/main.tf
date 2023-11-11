module "aci_application_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-application-profile"
  version = ">= 0.8.0"

  tenant      = "ABC"
  name        = "AP1"
  alias       = "AP1-ALIAS"
  description = "My Description"
}
