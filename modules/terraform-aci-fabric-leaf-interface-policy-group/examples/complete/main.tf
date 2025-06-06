module "aci_fabric_leaf_interface_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-leaf-interface-policy-group"
  version = ">= 0.8.0"

  name              = "LEAFS"
  link_level_policy = "default"
  monitoring_policy = "default"
}
