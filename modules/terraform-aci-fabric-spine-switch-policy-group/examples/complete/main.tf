module "aci_fabric_spine_switch_policy_group" {
  source  = "netascode/fabric-spine-switch-policy-group/aci"
  version = ">= 0.8.0"

  name                = "PG1"
  psu_policy          = "PSU1"
  node_control_policy = "NC1"
}
