module "aci_fabric_isis_bfd" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-isis-bfd"
  version = ">= 0.8.0"

  admin_state = true
}
