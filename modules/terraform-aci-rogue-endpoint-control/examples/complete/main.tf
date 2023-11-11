module "aci_rogue_endpoint_control" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-rogue-endpoint-control"
  version = ">= 0.8.0"

  admin_state          = true
  hold_interval        = 2000
  detection_interval   = 120
  detection_multiplier = 10
}
