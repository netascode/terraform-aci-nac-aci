module "aci_access_leaf_switch_profile" {
  source  = "netascode/access-leaf-switch-profile/aci"
  version = ">= 0.2.0"

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
