module "aci_oob_external_management_instance" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-oob-external-management-instance"
  version = ">= 0.8.0"

  name                   = "INST1"
  subnets                = ["0.0.0.0/0"]
  oob_contract_consumers = ["CON1"]
}
