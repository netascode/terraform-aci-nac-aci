module "aci_oob_endpoint_group" {
  source  = "netascode/oob-endpoint-group/aci"
  version = ">= 0.1.0"

  name                   = "OOB1"
  oob_contract_providers = ["OOB-CON1"]
}
