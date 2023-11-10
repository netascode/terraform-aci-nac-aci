module "aci_oob_external_management_instance" {
  source  = "netascode/oob-external-management-instance/aci"
  version = ">= 0.1.0"

  name                   = "INST1"
  subnets                = ["0.0.0.0/0"]
  oob_contract_consumers = ["CON1"]
}
