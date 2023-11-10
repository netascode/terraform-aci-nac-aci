module "aci_imported_contract" {
  source  = "netascode/imported-contract/aci"
  version = ">= 0.1.0"

  tenant          = "ABC"
  name            = "CON1"
  source_tenant   = "DEF"
  source_contract = "CON1"
}
