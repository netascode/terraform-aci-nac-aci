module "aci_fabric_leaf_interface_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-abric-leaf-interface-profile"
  version = ">= 0.8.0"

  name = "LEAF101"
}
