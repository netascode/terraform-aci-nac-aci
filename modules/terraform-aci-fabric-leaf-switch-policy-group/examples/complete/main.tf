module "aci_fabric_leaf_switch_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-leaf-switch-policy-group"
  version = ">= 0.8.0"

  name                = "LEAFS"
  psu_policy          = "PSU1"
  node_control_policy = "NC1"
}
