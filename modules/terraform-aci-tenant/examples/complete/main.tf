module "aci_tenant" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tenant"
  version = ">= 0.8.0"

  name        = "ABC"
  alias       = "ABC-ALIAS"
  description = "My Description"
}
