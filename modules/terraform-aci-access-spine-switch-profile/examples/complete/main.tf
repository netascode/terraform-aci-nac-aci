module "aci_access_spine_switch_profile" {
  source  = "netascode/access-spine-switch-profile/aci"
  version = ">= 0.2.1"

  name               = "SPINE1001"
  interface_profiles = ["SPINE1001"]
  selectors = [{
    name         = "SEL1"
    policy_group = "IPG1"
    node_blocks = [{
      name = "BLOCK1"
      from = 1001
      to   = 1001
    }]
  }]
}
