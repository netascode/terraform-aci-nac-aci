module "aci_tenant" {
  source  = "netascode/tenant/aci"
  version = ">= 0.8.0"

  name        = "ABC"
  alias       = "ABC-ALIAS"
  description = "My Description"
}
