module "aci_endpoint_loop_protection" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-endpoint-loop-protection"
  version = ">= 0.8.0"

  action               = "bd-learn-disable"
  admin_state          = true
  detection_interval   = 90
  detection_multiplier = 10
}
