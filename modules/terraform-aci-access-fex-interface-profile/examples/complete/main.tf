module "aci_access_fex_interface_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-fex-interface-profile"
  version = ">= 0.8.0"

  name = "FEX1"
}
