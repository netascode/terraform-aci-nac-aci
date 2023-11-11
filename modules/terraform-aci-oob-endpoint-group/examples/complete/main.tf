module "aci_oob_endpoint_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-oob-endpoint-group"
  version = ">= 0.8.0"

  name                   = "OOB1"
  oob_contract_providers = ["OOB-CON1"]
}
