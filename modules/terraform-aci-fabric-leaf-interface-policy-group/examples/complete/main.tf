module "aci_fabric_leaf_interface_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-leaf-interface-policy-group"
  version = ">= 1.0.2"

  name              = "LEAFS"
  description       = "All Leafs"
  link_level_policy = "default"
}
