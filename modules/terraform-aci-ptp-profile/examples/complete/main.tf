module "aci_ptp_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-aaep"
  version = ">= 0.8.0"

  name              = "PTP1"
  announce_interval = -3
  announce_timeout  = 2
  delay_interval    = -4
  sync_interval     = -4
  forwardable       = false
  template          = "telecom"
  mismatch_handling = "configured"
  priority          = 201
}
