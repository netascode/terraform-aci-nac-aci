module "aci_priority_flow_control_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-priority-flow-control-policy"
  version = "> 1.2.0"

  name        = "PFC_ON"
  description = "PFC enabled"
  admin_state = true
  auto_state  = false
}
