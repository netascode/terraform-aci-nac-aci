module "aci_access_spine_switch_policy_group" {
  source  = "netascode/access-spine-switch-policy-group/aci"
  version = ">= 0.1.0"

  name        = "SW-PG1"
  lldp_policy = "LLDP-ON"
}
