module "aci_access_spine_interface_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-spine-interface-policy-group"
  version = ">= 0.8.0"

  name              = "IPN"
  link_level_policy = "100G"
  cdp_policy        = "CDP-ON"
  aaep              = "AAEP1"
}
