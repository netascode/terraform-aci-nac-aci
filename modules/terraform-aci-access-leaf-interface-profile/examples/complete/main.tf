module "aci_access_leaf_interface_profile" {
  source  = "netascode/access-leaf-interface-profile/aci"
  version = ">= 0.1.0"

  name = "INT-PROF1"
}
