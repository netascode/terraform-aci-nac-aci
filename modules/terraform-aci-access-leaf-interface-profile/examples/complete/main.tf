module "aci_access_leaf_interface_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-leaf-interface-profile"
  version = ">= 0.8.0"

  name = "INT-PROF1"
}
