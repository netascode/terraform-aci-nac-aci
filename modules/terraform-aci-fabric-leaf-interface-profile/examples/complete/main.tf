module "aci_fabric_leaf_interface_profile" {
  source  = "netascode/fabric-leaf-interface-profile/aci"
  version = ">= 0.1.0"

  name = "LEAF101"
}
