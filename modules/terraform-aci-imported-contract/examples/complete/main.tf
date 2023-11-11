module "aci_imported_contract" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-imported-contract"
  version = ">= 0.8.0"

  tenant          = "ABC"
  name            = "CON1"
  source_tenant   = "DEF"
  source_contract = "CON1"
}
