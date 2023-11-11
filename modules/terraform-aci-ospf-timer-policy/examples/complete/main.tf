module "aci_ospf_timer_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-ospf-timer-policy"
  version = ">= 0.8.0"

  tenant                    = "ABC"
  name                      = "OSPFT1"
  description               = "My Description"
  reference_bandwidth       = 10000
  distance                  = 105
  max_ecmp                  = 4
  spf_init_interval         = 100
  spf_hold_interval         = 500
  spf_max_interval          = 2500
  max_lsa_reset_interval    = 20
  max_lsa_sleep_count       = 10
  max_lsa_sleep_interval    = 10
  lsa_arrival_interval      = 500
  lsa_group_pacing_interval = 20
  lsa_hold_interval         = 2500
  lsa_start_interval        = 10
  lsa_max_interval          = 2500
  max_lsa_num               = 40000
  max_lsa_threshold         = 100
  max_lsa_action            = "log"
  graceful_restart          = true
  router_id_lookup          = true
  prefix_suppression        = true
}
