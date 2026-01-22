module "aci_priority_flow_control_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-priority-flow-control-policy"
  version = ">= 0.8.0"

  name        = "PFC_ON"
  description = "PFC enabled"
  admin_state = "on"
}
