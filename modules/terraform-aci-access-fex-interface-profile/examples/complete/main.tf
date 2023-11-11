module "aci_access_fex_interface_profile" {
  source  = "netascode/access-fex-interface-profile/aci"
  version = ">= 0.8.0"

  name = "FEX1"
}
