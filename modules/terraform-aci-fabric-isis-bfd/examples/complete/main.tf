module "aci_fabric_isis_bfd" {
  source  = "netascode/fabric-isis-bfd/aci"
  version = ">= 0.8.0"

  admin_state = true
}
