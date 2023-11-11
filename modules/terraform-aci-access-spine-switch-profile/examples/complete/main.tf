module "aci_access_spine_switch_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-spine-switch-profile"
  version = ">= 0.8.0"

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
