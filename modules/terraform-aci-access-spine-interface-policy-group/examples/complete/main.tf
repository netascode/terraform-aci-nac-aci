module "aci_access_spine_interface_policy_group" {
  source  = "netascode/access-spine-interface-policy-group/aci"
  version = ">= 0.1.0"

  name              = "IPN"
  link_level_policy = "100G"
  cdp_policy        = "CDP-ON"
  aaep              = "AAEP1"
}
