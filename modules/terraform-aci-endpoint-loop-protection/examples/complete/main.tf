module "aci_endpoint_loop_protection" {
  source  = "netascode/endpoint-loop-protection/aci"
  version = ">= 0.1.0"

  action               = "bd-learn-disable"
  admin_state          = true
  detection_interval   = 90
  detection_multiplier = 10
}
