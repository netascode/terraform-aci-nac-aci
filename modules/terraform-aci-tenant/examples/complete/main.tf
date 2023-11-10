module "aci_tenant" {
  source  = "netascode/tenant/aci"
  version = ">= 0.1.0"

  name        = "ABC"
  alias       = "ABC-ALIAS"
  description = "My Description"
}
