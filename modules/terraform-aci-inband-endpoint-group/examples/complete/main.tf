module "aci_inband_endpoint_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-inband-endpoint-group"
  version = ">= 0.8.0"

  name                        = "INB1"
  vlan                        = 10
  bridge_domain               = "INB1"
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["I_CON1"]
}
