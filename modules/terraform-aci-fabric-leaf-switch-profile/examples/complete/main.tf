module "aci_fabric_leaf_switch_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-leaf-switch-profile"
  version = ">= 0.8.0"

  name               = "LEAF101"
  interface_profiles = ["PROF1"]
  selectors = [{
    name         = "SEL1"
    policy_group = "POL1"
    node_blocks = [{
      name = "BLOCK1"
      from = 101
      to   = 101
    }]
  }]
}
