module "aci_bgp_timer_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bgp-timer-policy"
  version = ">= 0.8.0"

  tenant                  = "ABC"
  name                    = "BGP1"
  description             = "My Description"
  graceful_restart_helper = false
  hold_interval           = 60
  keepalive_interval      = 30
  maximum_as_limit        = 20
  stale_interval          = "120"
}
